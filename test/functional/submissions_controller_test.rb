require 'test_helper'

class SubmissionsControlllerTest < ActionDispatch::IntegrationTest
  
  fixtures :all
  
  def setup
    @authenticated_exercise = exercises(:authenticated_submit)      # only authenticated users can submit, no need for file 
    @no_login_exercise      = exercises(:submit_without_login)      # submit witout login, no need for file

    @submission1 = submissions(:submission)             # Submission made by group1
    @submission2 = submissions(:another_submission)     # Submission made by group2
    @submission3 = submissions(:third_submission)       # Submission made by group3
    @submission4 = submissions(:fourth_submission)      # Submission made by group3 for submit_without_login exercise

    @group1 = groups(:group1)
    @group2 = groups(:group2)
    @unauthenticated_group = groups(:unauthenticated_group)   # Group which members have not authenticated themselves
  end


  context "when logged in as a teacher of the course" do
    setup do
      post session_path, params: { session: { email: 'teacher1@example.com', password: 'teacher1'} }
    end

    should "be able to view submission" do
      get submission_path(@submission1)
      assert_response :success
    end

    should "be able access new submission" do
      # Navigate to new submission
      get submit_path(exercise: @authenticated_exercise)
      assert_response :success
    end

    should "be able to create new submission for some group" do
      assert_difference 'Submission.count', 1 do
        post submit_path(exercise: @authenticated_exercise), params: { submission: { exercise_id: @authenticated_exercise.id, 
                                                                                     group_id: @group1.id} }
      end
      assert_redirected_to submit_path(exercise: @authenticated_exercise, group: @group1)
    end

    should "be able to delete submission" do
      assert_difference 'Submission.count', -1 do
        delete submission_path(@submission1)
      end
      assert_redirected_to exercise_path(@submission1.exercise)
    end

    should "be able to create new review for submission" do
      assert_difference 'Review.count', 1 do
        get review_submission_path(@submission1)
      end
      assert_response :redirect
    end

  end
  

  context "when logged in as a assistant" do
    setup do
      post session_path, params: { session: { email: 'assistant1@example.com', password: 'assistant1'} }
    end

    should "be able to view submission of group that has been assigned to them" do
      get submission_path(@submission1)
      assert_response :success
    end

    should "not be able to view submission of group that has not been assigned to them" do
      get submission_path(@submission2)
      assert_forbidden
    end

    should "be able access new submission" do
      # Navigate to new submission
      get submit_path(exercise: @authenticated_exercise)
      assert_response :success
    end

    should "not be able to create new submission for another group" do
      assert_no_difference 'Submission.count' do
        post submit_path(exercise: @authenticated_exercise), params: { submission: { exercise_id: @authenticated_exercise.id, 
                                                                                     group_id: @group1.id} }
      end
      assert_forbidden
    end

    should "be able to create new submission for themselves" do
      assert_difference 'Submission.count', 1 do
        post submit_path(exercise: @authenticated_exercise), params: { submission: { exercise_id: @authenticated_exercise.id } }
      end
      assert_response :redirect
      assert_not flash[:success].blank?
    end

    should "not be able to delete submission" do
      assert_no_difference 'Submission.count' do
        delete submission_path(@submission1)
      end
      assert_forbidden
    end

    should "be able to create new review for submission" do
      assert_difference 'Review.count', 1 do
        get review_submission_path(@submission1)
      end
      assert_response :redirect
    end

    should "not be able to create new review for submission of group that has not been assigned to them" do
      assert_no_difference 'Review.count' do
        get review_submission_path(@submission2)
      end
      assert_forbidden
    end
    
  end


  context "when logged in as a student" do
    setup do
      post session_path, params: { session: { email: 'student1@example.com', password: 'student1'} }
    end

    should "be able to view own submission" do
      get submission_path(@submission1)
      assert_response :success
    end

    should "not be able to view submission of another group" do
      get submission_path(@submission2)
      assert_forbidden
    end

    should "be able access new submission" do
      # Navigate to new submission
      get submit_path(exercise: @authenticated_exercise)
      assert_response :success
    end

    should "be able to create new submission for own group" do
      assert_difference 'Submission.count', 1 do
        post submit_path(exercise: @authenticated_exercise), params: { submission: { exercise_id: @authenticated_exercise.id, 
                                                                                     group_id: @group1.id} }
      end
      assert_redirected_to submit_path(exercise: @authenticated_exercise, group: @group1)
    end

    should "not be able to create new submission for another group" do
      assert_no_difference 'Submission.count' do
        post submit_path(exercise: @authenticated_exercise), params: { submission: { exercise_id: @authenticated_exercise.id, 
                                                                                     group_id: @group2.id} }
      end
      assert_forbidden
    end

    should "be able to create new submission for themselves" do
      assert_difference 'Submission.count', 1 do
        post submit_path(exercise: @authenticated_exercise), params: { submission: { exercise_id: @authenticated_exercise.id } }
      end
      assert_response :redirect
      assert_not flash[:success].blank?
    end

    should "be able to delete own submission" do
      assert_difference 'Submission.count', -1 do
        delete submission_path(@submission1)
      end
      assert_redirected_to exercise_path(@submission1.exercise)
    end

    # In exercise where there is no peer review
    should "not be able to create new review for submission" do
      assert_no_difference 'Review.count' do
        get review_submission_path(@submission3)
      end
      assert_forbidden
    end
  end


  context "when not logged in" do

    should "not be able to view submission of another group" do
      # Regular authenticated submissions only exercise
      get submission_path(@submission1)
      assert_redirected_to new_session_path
      # No login needed exercise
      get submission_path(@submission4)
      assert_redirected_to new_session_path
    end

    should "redirect new submission" do
      # Navigate to new submission
      get submit_path(exercise: @authenticated_exercise)
      assert_redirected_to new_session_path, "Should redirect to login if trying to submit to exercise that requires authentication"
      # Navigate to new submission
      get submit_path(exercise: @no_login_exercise)
      assert_redirected_to new_exercise_group_path(exercise_id: @no_login_exercise.id), "Should redirect to create group if trying to submit for unauthenticated exercise"
    end

    should "not be able to create new submission for another group" do
      # Try submit to exercise where authentication is required, -> should redirect to login
      assert_no_difference 'Submission.count' do
        post submit_path(exercise: @authenticated_exercise), params: { submission: { exercise_id: @authenticated_exercise.id, 
                                                                                     group_id: @group2.id} }
      end
      assert_redirected_to new_session_path, "Should redirect to login if trying to submit to exercise that requires authentication"
      # Try submit to exercise where authentication is not required, -> should be forbidden
      assert_no_difference 'Submission.count' do
        post submit_path(exercise: @no_login_exercise), params: { submission: { exercise_id: @no_login_exercise.id, 
                                                                                group_id: @group1.id},
                                                                  group_token: @unauthenticated_group.access_token }
      end
      assert_forbidden
    end
    
    # We pretend unauthenticated user has just created a new group where user is given 
    # group_token for created @unauthenticated_group. Without login user can submit if they
    # have group_token.
    should "be able to create new submission for unauthenticated group" do
      assert_difference 'Submission.count', 1 do
        post submit_path(exercise: @no_login_exercise), params: { submission: { exercise_id: @no_login_exercise.id,
                                                                                group_id:  @unauthenticated_group.id},
                                                                  group_token: @unauthenticated_group.access_token }
      end
      assert_response :redirect
      assert_not flash[:success].blank?
    end

    should "redirect create new submission for exercise that needs authentication to login" do
      assert_no_difference 'Submission.count' do
        post submit_path(exercise: @authenticated_exercise), params: { submission: { exercise_id: @authenticated_exercise.id,
                                                                                     group_id: @unauthenticated_group.id },
                                                                       group_token: @unauthenticated_group.access_token }
      end
      assert_redirected_to new_session_path
    end 

    should "redirect delete submission to login" do
      assert_no_difference 'Submission.count' do
        delete submission_path(@submission1)
      end
      assert_redirected_to new_session_path
    end
  end

end
