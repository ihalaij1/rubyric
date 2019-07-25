require 'test_helper'

class TeachersControllerTest < ActionDispatch::IntegrationTest
  
  fixtures :users, :courses, :course_instances
  
  def setup
    @course = courses(:course_with_many_teachers)
    @user   = users(:student3)              # test adding user as a teacher
    @secondary_teacher = users(:teacher2)   # test removing teacher
  end

  context "when not logged in" do
    should "not be able to add teacher" do
      assert_no_difference "Course.find(@course.id).teachers.count" do
        post course_teachers_path(@course), params: { course_id: @course.id, user_id: @user.id }, xhr: true
      end
      assert_redirected_to new_session_path
    end

    should "not be able to remove teacher" do
      assert_no_difference "Course.find(@course.id).teachers.count" do
        delete course_teacher_path(@course, @secondary_teacher), xhr: true
      end
      assert_redirected_to new_session_path
    end
  end

  context "when logged in as a student" do
    setup do
      # Log in
      post session_path, params: { session: { email: 'student1@example.com', password: 'student1'} }
    end

    should "not be able to add teacher" do
      assert_no_difference "Course.find(@course.id).teachers.count" do
        post course_teachers_path(@course), params: { course_id: @course.id, user_id: @user.id }, xhr: true
      end
      assert_forbidden
    end

    should "not be able to remove teacher" do
      assert_no_difference "Course.find(@course.id).teachers.count" do
        delete course_teacher_path(@course, @secondary_teacher), xhr: true
      end
      assert_forbidden
    end
  end

  context "when logged in as a teacher" do
    setup do
      post session_path, params: { session: { email: 'teacher1@example.com', password: 'teacher1'} }
    end
    
    should "be able to add teacher" do
      assert_difference "Course.find(@course.id).teachers.count", 1 do
        post course_teachers_path(@course), params: { course_id: @course.id, user_id: @user.id }, xhr: true
      end
      assert_response :success
      assert Course.find(@course.id).teachers.include?(@user), "User should become teacher"
    end

    should "be able to remove teacher" do
      assert_difference "Course.find(@course.id).teachers.count",-1 do
        delete course_teacher_path(@course, @secondary_teacher), xhr: true
      end
      assert_response :success
      assert !Course.find(@course.id).teachers.include?(@secondary_teacher), "User should no longer be teacher"
    end
    
  end

  context "When logged in as an admin" do
    setup do
      post session_path, params: { session: { email: 'admin@example.com', password: 'admin'} }
    end

    should "be able to add teacher" do
      assert_difference "Course.find(@course.id).teachers.count", 1 do
        post course_teachers_path(@course), params: { course_id: @course.id, user_id: @user.id }, xhr: true
      end
      assert_response :success
      assert Course.find(@course.id).teachers.include?(@user), "User should become teacher"
    end

    should "be able to remove teacher" do
      assert_difference "Course.find(@course.id).teachers.count",-1 do
        delete course_teacher_path(@course, @secondary_teacher), xhr: true
      end
      assert_response :success
      assert !Course.find(@course.id).teachers.include?(@secondary_teacher), "User should no longer be teacher"
    end
    
  end
  
end
