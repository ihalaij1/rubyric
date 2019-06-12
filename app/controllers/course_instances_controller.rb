class CourseInstancesController < ApplicationController
  before_action :login_required, except: [:show, :aplus_exercise]

  # GET /course_instances/1
  def show
    @course_instance = CourseInstance.find(params[:id])
    load_course

    if lti_headers_present?
      return unless authenticate_lti_signature
      return unless login_lti_user
    else
      return unless login_required
    end

    @allow_edit = @course.has_teacher(current_user) || is_admin?(current_user)

    log "view_course_instance #{@course_instance.id}"
  end

  # GET /course_instances/new
  # GET /course_instances/new.xml
  def new
    # Load course
    if params[:course_id]
      @course = Course.find(params[:course_id])

      # Authorize
      return access_denied unless @course.has_teacher(current_user) || is_admin?(current_user)

      load_course
    else
      @course = Course.new
    end

    @pricing = current_user.get_pricing
    @pricing.planned_students = 20
    policy = ['unauthenticated', 'authenticated', 'enrolled', 'lti'].include?(params[:submission_policy]) ? params[:submission_policy] : 'unauthenticated'
    @course_instance = CourseInstance.new(submission_policy: policy, lti_consumer: params[:lti_consumer], lti_context_id: params[:lti_context_id])
    @course_instance.course = @course
    # :name => Time.now.year

    @ask_agree_terms = Rails.configuration.ask_agree_terms    # whether or not it is needed to ask user to agree to the terms

    render :action => 'new', :layout => 'narrow-new'
    log "create_course_instance #{@pricing.shortname} #{@course.id}"
  end

  # GET /course_instances/1/edit
  def edit
    @course_instance = CourseInstance.find(params[:id])
    load_course

    # Authorize
    return access_denied unless @course.has_teacher(current_user) || is_admin?(current_user)

    @pricing = @course_instance.pricing

    render action: 'edit', layout: 'narrow-new'
    log "edit_course_instance #{@course_instance.id}"
  end

  # POST /course_instances
  # POST /course_instances.xml
  def create
    @ask_agree_terms = Rails.configuration.ask_agree_terms
    @pricing = current_user.get_pricing
    @pricing.planned_students = params[:planned_students].to_i

    @course_instance = CourseInstance.new(course_instance_params)

    # If configurations say it is not needed to ask user to agree to terms
    # set course instances agree_terms attribute to true ('1')
    @course_instance.agree_terms = '1' unless @ask_agree_terms
    course_instance_valid = @course_instance.valid?

    if !params[:course_instance][:course_id].blank?
      @course = Course.find(params[:course_instance][:course_id])
      return access_denied unless @course.has_teacher(current_user) || is_admin?(current_user)
      course_valid = true
    else
      @course = Course.new(name: params[:course_name])
      course_valid = @course.valid?
    end

    if course_valid && course_instance_valid
      @pricing.save

      if @course.new_record?
        @course.organization_id = current_user.organization_id
        @course.save
        @course.teachers << current_user
      end

      @course_instance.pricing_id = @pricing.id
      @course_instance.course_id = @course.id
      @course_instance.save

      current_user.course_count += 1
      current_user.save

      redirect_to @course_instance
      log "create_course_instance success #{@course_instance.id}"
    else
      @course_instance.course = @course
      render action: 'new', layout: 'narrow-new'
      log "create_course_instance invalid #{@course_instance.id} #{@course_instance.errors.full_messages.join('. ')}"
    end
  end

  # PUT /course_instances/1
  def update
    @course_instance = CourseInstance.find(params[:id])
    load_course

    # Authorize
    return access_denied unless @course.has_teacher(current_user) || is_admin?(current_user)

    @pricing = @course_instance.pricing
    @course_instance.agree_terms = '1'
    if @course_instance.update_attributes(course_instance_params)
      if @pricing
        @pricing.planned_students = params[:planned_students].to_i
        @pricing.save
      end

      flash[:success] = t(:instance_updated_flash)
      redirect_to @course_instance
      log "edit_course_instance success #{@course_instance.id}"
    else
      render action: "edit", layout: 'narrow-new'
      log "edit_course_instance fail #{@course_instance.id} #{@course_instance.errors.full_messages.join('. ')}"
    end
  end

  # DELETE /course_instances/1
  def destroy
    @course_instance = CourseInstance.find(params[:id])
    load_course

    return access_denied unless is_admin?(current_user)

    log "delete_course_instance #{@course_instance.id}"

    #Destroy
    @course_instance.destroy
    redirect_to(@course)
  end


#   # Ajax action for uploading a csv student list
#   def students_csv
#     @course_instance = CourseInstance.find_by_id(params[:course_instance_id])
#     load_course
#
#     return access_denied unless @course.has_teacher(current_user) || is_admin?(current_user)
#
#     if params[:paste]
#       @course_instance.add_students_csv(params[:paste])
#     end
#
#     render partial: 'user', collection: @course_instance.students, locals: { iid: @course_instance.id }
#   end
#
#
#   # Ajax action for uploading a csv stundent list
#   def add_assistants_csv
#     @course_instance = CourseInstance.find_by_id(params[:course_instance_id])
#     load_course
#
#     return access_denied unless @course.has_teacher(current_user) || is_admin?(current_user)
#
#     if params[:paste]
#       @course_instance.add_assistants_csv(params[:paste])
#     end
#
#     render partial: 'user', collection: @course_instance.assistants, locals: { iid: @course_instance.id }
#   end
#


  def create_example_groups
    @course_instance = CourseInstance.find(params[:course_instance_id])
    load_course
    authorize! :update, @course_instance

    @course_instance.create_example_groups

    redirect_to @course_instance
    log "create_example_groups #{@course_instance.id}"
  end

  def send_feedback_bundle
    @course_instance = CourseInstance.find(params[:course_instance_id])
    authorize! :update, @course_instance

    Review.delay.deliver_bundled_reviews(@course_instance.id)
    flash[:success] = 'Sending feedback mails'

    redirect_to @course_instance
    log "send_feedback_bundle #{@course_instance.id}"
  end
  
  # A+ calls this. Redirects to submit to exercise if exercise exists. Otherwise creates the exercise and then redirects to it.
  def aplus_exercise
    # Authorized IP?
    remote_ip = (request.env['HTTP_X_FORWARDED_FOR'] || request.remote_ip).split(',').first
    unless APLUS_IP_WHITELIST.include? remote_ip
      @heading = 'LTI error: Requests only allowed from A+'
      render template: 'shared/error'
      return false
    end
    # Check that neccessary lti related params are included in the request
    if params['oauth_consumer_key'].blank? || params[:context_id].blank? || params[:resource_link_id].blank?
      @heading = 'Not enough parameters'
      render template: 'shared/error', layout: 'wide'
      return false
    end
    # Find the course_instance
    @course_instance = CourseInstance.where(lti_consumer: params['oauth_consumer_key'], lti_context_id: params[:context_id]).first
    unless @course_instance
      @heading = 'This LTI course is not configured'
      logger.warn "LTI login failed. Could not find a course instance with lti_consumer=#{params['oauth_consumer_key']}, lti_context_id=#{params[:context_id]}"
      render template: 'shared/error'
      return false
    end
    # Find exercise and create one if it does not exist yet
    @exercise = Exercise.where(course_instance_id: @course_instance.id, lti_resource_link_id: params[:resource_link_id]).first
    unless @exercise
      sub_url = params[:submission_url]
      sub_url = (sub_url || "").split("grader").first #.sub('plus', '172.18.0.3')
      exercise_name    = params[:resource_link_title] #JSON.load(open(sub_url)).display_name
      submit_type      = 'file'
      review_mode      = 'annotation'
      resource_link_id = params[:resource_link_id]
      @exercise = Exercise.new(course_instance: @course_instance, name: exercise_name,
                               submission_type: submit_type,      review_mode: review_mode,
                               lti_resource_link_id: resource_link_id)
      if !@exercise.save
        @heading = 'Failed to configure exercise'
        render template: 'shared/error', layout: 'wide'
        return false
      end
    end
    redirect_to aplus_get_path(@exercise, request.parameters)
  end

  private

    def course_instance_params
      params.require(:course_instance).permit(:name, :locale, :submission_policy, :agree_terms, :active, :lti_consumer, :lti_context_id)
    end

end
