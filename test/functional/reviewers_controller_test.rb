require 'test_helper'

class ReviewsControllerTest < ActionDispatch::IntegrationTest
  
  fixtures :users, :courses, :course_instances
  
  def setup
    @instance  = course_instances(:with_many_assistants)
    @course    = courses(:course_with_many_teachers)
    @user      = users(:student3)         # test adding user as an assistant
    @assistant = users(:assistant2)       # test removing assistant
  end

  context "when not logged in" do
    should "not be able to add assistant" do
      assert_no_difference "CourseInstance.find(@instance.id).assistants.count" do
        post course_instance_reviewers_path(@instance), params: { course_instance_id: @instance.id, user_id: @user.id }, xhr: true
      end
      assert_redirected_to new_session_path
    end

    should "not be able to remove assistant" do
      assert_no_difference "CourseInstance.find(@instance.id).assistants.count" do
        delete course_instance_reviewer_path(@instance, @assistant), xhr: true
      end
      assert_redirected_to new_session_path
    end
  end

  context "when logged in as an assistant" do
    setup do
      post session_path, params: { session: { email: 'assistant1@example.com', password: 'assistant1'} }
    end

    should "not be able to add assistant" do
      assert_no_difference "CourseInstance.find(@instance.id).assistants.count" do
        post course_instance_reviewers_path(@instance), params: { course_instance_id: @instance.id, user_id: @user.id }, xhr: true
      end
      assert_forbidden
    end

    should "not be able to remove assistant" do
      assert_no_difference "CourseInstance.find(@instance.id).assistants.count" do
        delete course_instance_reviewer_path(@instance, @assistant), xhr: true
      end
      assert_forbidden
    end

    
  end

  context "when logged in as a teacher" do
    setup do
      post session_path, params: { session: { email: 'teacher1@example.com', password: 'teacher1'} }
    end
    
    should "be able to add assistant" do
      assert_difference "CourseInstance.find(@instance.id).assistants.count", 1 do
        post course_instance_reviewers_path(@instance), params: { course_instance_id: @instance.id, user_id: @user.id }, xhr: true
      end
      assert_response :success
      assert CourseInstance.find(@instance.id).assistants.include?(@user)
    end

    should "be able to remove assistant" do
      assert_difference "CourseInstance.find(@instance.id).assistants.count", -1 do
        delete course_instance_reviewer_path(@instance, @assistant), xhr: true
      end
      assert_response :success
      assert !CourseInstance.find(@instance.id).assistants.include?(@assistant)
    end
    
  end

  context "When logged in as an admin" do
    setup do
      post session_path, params: { session: { email: 'admin@example.com', password: 'admin'} }
    end

    should "be able to add assistant" do
      assert_difference "CourseInstance.find(@instance.id).assistants.count", 1 do
        post course_instance_reviewers_path(@instance), params: { course_instance_id: @instance.id, user_id: @user.id }, xhr: true
      end
      assert_response :success
      assert CourseInstance.find(@instance.id).assistants.include?(@user)
    end

    should "be able to remove assistant" do
      assert_difference "CourseInstance.find(@instance.id).assistants.count", -1 do
        delete course_instance_reviewer_path(@instance, @assistant), xhr: true
      end
      assert_response :success
      assert !CourseInstance.find(@instance.id).assistants.include?(@assistant)
    end
    
  end
  
end
