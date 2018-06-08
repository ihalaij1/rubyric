require 'test_helper'

class CoursesControllerTest < ActionDispatch::IntegrationTest
  fixtures :users, :courses

  def setup
    @course = courses(:course)
  end

  # Tests for not logged in
  context "when not logged in" do
    should "not get index" do
      get courses_path
      assert_redirected_to new_session_path
    end

    should "not get course" do
      get course_path(@course)
      assert_redirected_to new_session_path
    end

    # Courses do not have their own new path thus cannot be tested
    # Test shall be carried out at course_instances_controller_test.rb
    #should "not get new" do
    #  get new_course_path
    #  assert_redirected_to new_session_path
    #end

    should "not get edit" do
      get edit_course_path(@course)
      assert_redirected_to new_session_path
    end

    # Courses do not have their own create path thus cannot be tested
    # Test shall be carried out at course_instances_controller_test.rb
    #should "not be able to create course" do
    #  assert_no_difference 'Course.count' do
    #    post courses_path, params: { course: { code: '93765', name: 'New course' } }
    #  end
    #end

    should "not be able to update course" do
      patch course_path(@course), params: {course: { code: '39777', name: 'New name' } }
      assert_redirected_to new_session_path
    end

    # Courses_controller does not have delete-method thus it cannot be tested
    #should "not be able to delete course" do
    #  assert_no_difference 'Course.count' do
    #    delete course_path(@course)
    #  end
    #  assert_redirected_to new_session_path
    #end
    
#     should "not get teachers" do
#       get :teachers, :id => courses(:course).id
#       assert_redirected_to new_session_path
#     end
    
    # TODO: add/remove teachers
  end
  
   # Tests for user that has been logged in as a student
  context "when logged in as a student" do
    setup do
      post session_path, params: { session: { email: 'student1@example.com', password: 'student1'} }
    end

    should "get index" do
      get courses_path
      assert_not_nil :courses
      assert_response :success
      #assert_template :index
    end

    should "get course" do
      get course_path(@course)
      assert_not_nil :course
      assert_response :success
      #assert_template :show
    end

    # Courses do not have their own new path thus cannot be tested
    # Test shall be carried out at course_instances_controller_test.rb
    #should "get new" do
    #  get new_course_path
    #  assert_response :success
    #  #assert_template :new
    #end

    should "not get edit" do
      get edit_course_path(@course)
      assert_forbidden
    end

    # Courses do not have their own create path thus cannot be tested
    # Test shall be carried out at course_instances_controller_test.rb
    #should "be able to create course" do
    #  assert_difference('Course.count', 1) do 
    #    post courses_path, params: { course: { code: '9765', name: 'New course' } }
    #  end
    #  
    #  #assert_redirected_to new_course_course_instance_path(:course)
    #end

    should "not be able to update course" do
      old_code = @course.code
      patch course_path(@course), params: { course: { code: '93777', name: 'New name' } }
      assert_forbidden
      assert @course.code, old_code
    end
    
    # Courses_controller does not have delete-method thus it cannot be tested
    #should "not be able to delete course" do
    #  assert_no_difference 'Course.count' do
    #    delete course_path(@course)
    #  end
    #  assert_forbidden
    #end

  end
 
  # Tests for a user that has been logged in as a teacher (assigned to @course)
  context 'when logged in as a teacher' do
    setup do
      post session_path, params: { session: { email: 'teacher1@example.com', password: 'teacher1'} }
    end
    
    should "get index" do
      get courses_path
      assert_not_nil :courses
      assert_response :success
      #assert_template :index
    end

    should "get course" do
      get course_path(@course)
      assert_not_nil :course
      assert_response :success
      #assert_template :show
    end
    
    # Courses do not have their own new path thus cannot be tested
    # Test shall be carried out at course_instances_controller_test.rb
    #should "get new" do
    #  get new_course_path
    #  
    #  assert_response :success
    #  assert_template :new
    #end

    should "get edit" do
      get edit_course_path(@course)
      assert_response :success
      #assert_template :edit
    end
    
    # Courses do not have their own create path thus cannot be tested
    # Test shall be carried out at course_instances_controller_test.rb
    #should "be able to create course" do
    #  assert_difference('Course.count', 1) do 
    #    post courses_path, params: { course: { code: '93765', name: 'New course' } }
    #  end
    #  assert_redirected_to new_course_course_instance_path(:course)
    #end

    should "be able to update course" do
      patch course_path(@course), params: { course: { code: '93777', name: 'New name' } }
      assert_redirected_to course_path(@course)
    end
    
    # Courses_controller does not have delete-method thus it cannot be tested
    #should "be able to delete course" do
    #  assert_difference('Course.count', -1) do 
    #    delete course_path(@course)
    #  end
    #  assert_redirected_to courses_path
    #end
    
#     should "get teachers" do
#       get :teachers, :id => courses(:course).id
#       
#       assert_response :success
#       assert_template :teachers
#     end
  end
  
end
