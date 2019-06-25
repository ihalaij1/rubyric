class FeedbackMailer < ActionMailer::Base
  default :from => RUBYRIC_EMAIL
  default_url_options[:host] = RUBYRIC_HOST

  # Sends the review by email to the students
  def review(review)
    @review = review
    @exercise = @review.submission.exercise
    @course_instance = @exercise.course_instance
    @course = @course_instance.course
    @grader = @review.user
    group = review.submission.group

    if !@course.email.blank?
      headers["Reply-to"] = @course.email
    elsif !@exercise.anonymous_graders && @grader && !@grader.email.blank?
      headers["Reply-to"] = @grader.email
    end

    # Collect receiver addresses
    recipients = []
    group.group_members.each do |member|
      if !member.email.blank?
        recipients << member.email
      elsif member.user && !member.user.email.blank?
        recipients << member.user.email
      end
    end

    if recipients.empty?
      # TODO: raise an exception with an informative message
      review.status = 'finished'
      review.save
      return
    end

    # Attachment
    unless @review.filename.blank?
      attachments[@review.filename] = File.read(@review.full_filename)
    end

    subject = "#{@course.full_name} - #{@exercise.name}"

    if review.type == 'AnnotationAssessment'
      template_name = 'annotation'
      @review_url = review_url(review.id, :group_token => group.access_token, :protocol => 'https://')
    else
      template_name = 'review'
    end

    I18n.with_locale(@course_instance.locale || I18n.locale) do
      mail(
        :to => recipients.join(","),
        :subject => subject,
        :template_path => 'feedback_mailer',
        :template_name => template_name
      )
      #:reply_to => from,
    end

    # Set status
    review.status = 'mailed'
    review.save
  end

  def bundled_reviews(course_instance, user, reviews, exercise_grades)
    return if user.email.blank?

    @reviews = reviews
    @exercise_grades = exercise_grades
    @course_instance = course_instance
    @course = @course_instance.course

    from = @course.email
    from = RUBYRIC_EMAIL if from.blank?

    subject = "#{@course.full_name}"

    # Attachments
    @reviews.each do |review|
      attachments[review.filename] = File.read(review.full_filename) unless review.filename.blank?
    end

    I18n.with_locale(@course_instance.locale || I18n.locale) do
      mail(
        :to => user.email, :from => from, :subject => subject
      )
    end
  end

  def delivery_errors(errors)
    @errors = errors
    mail(:to => ERRORS_EMAIL, :subject => '[Rubyric] Undelivered feedback mails')
  end

  # Sends grades and feedback to A+
  # send_grade_mode tells whether sent grade should be average of sent reviews
  # or the best grade, best grade is used if send_grade_mode is blank
  def aplus_feedback(submission_id, review_ids, send_grade_mode = nil)
    submission = Submission.find(submission_id)
    group = submission.group
    @exercise = submission.exercise
    @course_instance = @exercise.course_instance
    @course = @course_instance.course
    subject = "#{@course.full_name} - #{@exercise.name}"
    peer_reviews_required = @exercise.peer_review?
    always_pass = @exercise.rubric_grading_mode == 'always_pass'
    @reviews = Review.where(id: review_ids, status: ["finished", "mailing", "mailed"])
    
    # Calculate grade to be sent to A+
    # Ignores non-numerical grades
    average = send_grade_mode == "average"
    best_grade = send_grade_mode.blank? || send_grade_mode == "best_grade"
    grade = 0
    count = 0
    @reviews.each do |review|
      cast = Review.cast_grade(review.grade)
      if average && !cast.is_a?(String)
        grade += cast
        count += 1
      elsif best_grade && !cast.is_a?(String) && grade < cast
        grade = cast
      end
    end
    grade = 1.0 * grade / count if average && count > 0
    logger.debug "GRADE: #{grade}"
    
    # Get max grade
    max_grade = @exercise.max_grade
    
    if always_pass
      max_grade = 1
      grade = 1
    end
    # A+ always requires max_grade
    if max_grade.nil? || max_grade == 0
      max_grade = 1
      grade = 1
      logger.warn "No max_grade for exercise #{@exercise.id}."
    end

    # Get feedback (same for every member)
    feedback = I18n.with_locale(@course_instance.locale || I18n.locale) do
      render_to_string(action: :aplus).to_str
    end

    # Deliver
    success = false
    response = nil
    if @reviews.empty? || !submission
      logger.info "Not enough reviews for group #{group.id}"
    elsif grade.nil? || grade.is_a?(String)
      logger.info "No numeric grade for group #{group.id}."
    elsif !submission.lti_launch_params.blank?
      # Send grades via LTI
      params = JSON.parse(submission.lti_launch_params)
      consumer_key = params['oauth_consumer_key']
      secret = OAUTH_CREDS[consumer_key]
      logger.debug params
      logger.debug params.class.name
      provider = IMS::LTI::ToolProvider.new(consumer_key, secret, params)

      response = provider.post_replace_result!(combined_grade / max_grade)
      if response.success? || response.processing?
        success = true
      elsif response.unsupported?
        logger.warn "Failed to send grades for group #{group.id} via LTI (unspported)."
      else
        logger.warn "Failed to send grades for group #{group.id} via LTI."
      end

    elsif !submission.aplus_feedback_url.blank?
      # Send grades to A+
      if Rails.env == 'production'
        response = RestClient.post(submission.aplus_feedback_url, {points: grade.round, max_points: max_grade.round, feedback: feedback, notify: 'yes'})
        success = true if response.code == 200
      else
        logger.debug "Skipping A+ API call in development environment. #{submission.aplus_feedback_url}, points: #{grade.round}, max_points: #{max_grade.round}"
      end
    end
    
    if success
      Review.where(:id => review_ids, :status => ['finished', 'mailing']).update_all(:status => 'mailed')
    else
      Review.where(:id => review_ids, :status => 'mailing').update_all(:status => 'finished')
      logger.error "Failed to submit points to A+"
      logger.error response
    end
  end

  def submission_received(submission_id)
    @submission = Submission.find(submission_id)
    @group = @submission.group
    @exercise = @submission.exercise
    @course_instance = @exercise.course_instance
    @course = @course_instance.course

    subject = "#{@course.full_name} - #{@exercise.name}"

    # FIXME: repetition, see review()
    recipients = []
    @group.group_members.each do |member|
      if !member.email.blank?
        recipients << member.email
      elsif member.user && !member.user.email.blank?
        recipients << member.user.email
      end
    end

    I18n.with_locale(@course_instance.locale || I18n.locale) do
      mail(
        :to => recipients.join(","),
        :subject => subject
      )
    end

  end

end
