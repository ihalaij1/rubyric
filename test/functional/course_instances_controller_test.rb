require 'test_helper'

class CourseInstancesControllerTest < ActionDispatch::IntegrationTest
  
  fixtures :users, :courses, :course_instances, :exercises
  
  # Require login
  #should_require_login :show, :new, :edit, :create, :destroy
  
  def setup
    @active = course_instances(:active)
    @course = courses(:course)
  end

  context "when not logged in" do
    should "not be able to create a new course and course instance" do
      assert_no_difference 'Course.count' do
        assert_no_difference 'CourseInstance.count' do
          post course_instances_path, params: { course_instance: { course_name: 'Non-logged-in Course',
                                                                   name:        'First Instance',
                                                                   agree_terms: '1' }}
        end
      end
      assert_redirected_to new_session_path
    end

    should "not be able to delete course instance" do
      assert_no_difference 'CourseInstance.count' do 
        delete course_instance_path(@active)
      end
      assert_redirected_to new_session_path
    end
  end

  context "when logged in as a student" do
    setup do
      # Log in
      post session_path, params: { session: { email: 'student1@example.com', password: 'student1'} }
      #login_as(users(:student1))
    end

    should "be able to access course instance" do
      get course_instance_path(@active)
      assert_not_nil :course_instance
      assert_response :success
      #assert_template :show
    end

    should "not be able to access to new course_instance to someone else's course" do
      get new_course_course_instance_path(@course)
      assert_forbidden
    end
    
    should "not be able to access to edit course_instance of someone else" do
      get edit_course_instance_path(@active)
      assert_forbidden
    end

    should "not be able to create course instance to someone else's course" do
      assert_no_difference 'CourseInstance.count' do 
        post course_instances_path, params: { course_instance: { course_id: @course.id, name: 'Test', agree_terms: '1'} }
      end
      assert_forbidden
    end
    
    should "not be able to update course instance" do
      patch course_instance_path(@active), params: { course_instance: { name: 'New name', description: 'New description', active: false } }
      assert_forbidden
    end
    
    should "not be able to delete course instance" do
      assert_no_difference 'CourseInstance.count' do 
        delete course_instance_path(@active)
      end
      assert_forbidden
    end

    should "be able to create a new course and course instance" do
      assert_difference 'Course.count', 1 do
        assert_difference 'CourseInstance.count', 1 do
          post course_instances_path, params: { course_name: "Fabulous course", 
                                                course_instance: { name:        'First Instance',
                                                                   agree_terms: '1' } }
        end
      end
    end

#     should "not be able to access list of students" do
#       get :students, :id => course_instances(:active).id
#       assert_forbidden
#     end

  end

  context "when logged in as a teacher" do
    setup do
      post session_path, params: { session: { email: 'teacher1@example.com', password: 'teacher1'} }
    end
    
    should "get instance" do
      get course_instance_path(@active)
      
      assert_not_nil :course_instance
      assert_response :success
      #assert_template :show
    end

    should "be able to access new" do
      get new_course_instance_path
      assert_not_nil :course_instance
      assert_response :success
      #assert_template :new
    end
    
    should "be able to access edit" do
      get edit_course_instance_path(@active)
      assert_not_nil :course_instance
      assert_response :success
      #assert_template :edit
    end

    should "be able to create course instance" do
      assert_difference 'CourseInstance.count', 1 do 
        post course_instances_path, params: { course_instance: { course_id: @course.id, name: 'Test', agree_terms: '1'} }
      end
    end
    
    should "be able to update course instance" do
      patch course_instance_path(@active), params: { course_instance: { name: 'New name', active: false } }
      assert_redirected_to course_instance_path(@active)
      assert_not_nil flash[:success], "Should set flash[:success]"
      
      assert_equal_attributes CourseInstance.find(@active.id), {name: 'New name', active: false}
    end

    should "not be able to delete course instance" do
      assert_no_difference 'CourseInstance.count' do 
        delete course_instance_path(@active)
      end
      assert_forbidden
    end

    should "be able to create a new course and course instance" do
      assert_difference 'Course.count', 1 do
        assert_difference 'CourseInstance.count', 1 do
          post course_instances_path, params: { course_name: "Fabulous course", 
                                                course_instance: { name:        'First Instance',
                                                                   agree_terms: '1' } }
        end
      end
    end
    
#     should "be able to access list of students" do
#       get :students, :id => course_instances(:active).id
#       
#       assert_not_nil assigns(:course_instance)
#       assert_response :success
#       assert_template :students
#     end
#     
#     should "be able to upload list of students" do
#       test_file = fixture_file_upload('files/students.csv','text/plain')
#       post :students, :id => course_instances(:active).id, :csv => {:file => test_file}
#       
#       old_student = User.find_by_studentnumber('00001')
#       assert_equal old_student.firstname, 'Student'
#       assert_equal old_student.lastname, '1'
#       assert_equal old_student.email, 'student1@example.com'
#       
#       new_student = User.find_by_studentnumber('93654')
#       assert_equal new_student.firstname, 'New'
#       assert_equal new_student.lastname, 'Student'
#       assert_equal new_student.email, 'newbie@example.com'
#     end
  end

  context "When logged in as an admin" do
    setup do
      post session_path, params: { session: { email: 'admin@example.com', password: 'admin'} }
    end

    should "get instance" do
      get course_instance_path(@active)
      
      assert_not_nil :course_instance
      assert_response :success
    end

    should "be able to access new" do
      get new_course_instance_path
      assert_not_nil :course_instance
      assert_response :success
    end
    
    should "be able to access edit" do
      get edit_course_instance_path(@active)
      assert_not_nil :course_instance
      assert_response :success
    end

    should "be able to create course instance" do
      assert_difference 'CourseInstance.count', 1 do 
        post course_instances_path, params: { course_instance: { course_id: @course.id, name: 'Test', agree_terms: '1'} }
      end
    end
    
    should "be able to update course instance" do
      patch course_instance_path(@active), params: { course_instance: { name: 'New name', active: false } }
      assert_redirected_to course_instance_path(@active)
      assert_not_nil flash[:success], "Should set flash[:success]"
      
      assert_equal_attributes CourseInstance.find(@active.id), {name: 'New name', active: false}
    end

    should "be able to delete course instance" do
      assert_difference 'CourseInstance.count', -1 do 
        delete course_instance_path(@active)
      end
      assert_redirected_to course_path(@course)
    end

    should "be able to create a new course and course instance" do
      assert_difference 'Course.count', 1 do
        assert_difference 'CourseInstance.count', 1 do
          post course_instances_path, params: { course_name: "Fabulous course", 
                                                course_instance: { name:        'First Instance',
                                                                   agree_terms: '1' } }
        end
      end
    end
    
  end
  
end
