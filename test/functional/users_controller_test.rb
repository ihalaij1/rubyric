require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  fixtures :users
  
  def setup
    @teacher = users(:teacher1)
    @student = users(:student1)
  end

  context "when not logged in" do 

    should "be able to create new user" do
      assert_difference "User.count", 1 do
        post users_path, params: { user: { firstname: "Some",
                                           lastname: "Body",
                                           email: "some@example.com", 
                                           password: "foobarbaz" }}
      end
      assert_redirected_to root_path
    end

    should "not be able to create admin" do
      assert_difference "User.count", 1 do
        assert_no_difference "User.where(admin: true).count" do
          post users_path, params: { user: { firstname: "Some",
                                             lastname: "Body",
                                             email: "some@example.com", 
                                             password: "foobarbaz",
                                             admin: true }}
        end
      end
      assert_redirected_to root_path
    end

    should "redirect update user" do
      user_firstname = @student.firstname
      user_lastname  = @student.lastname
      patch user_path(@student), params: { user: {  firstname: "Some",
                                                    lastname: "Body" } }
      assert_redirected_to new_session_path
      assert_equal_attributes User.find(@student.id), { firstname: user_firstname,
                                                        lastname:  user_lastname}
    end  

  end

  context "when logged in" do
    setup do
      post session_path, params: { session: { email: "teacher1@example.com", password: "teacher1" }}
    end

    should "not be able to update another user" do
      user_firstname = @student.firstname
      user_lastname  = @student.lastname
      patch user_path(@student), params: { user: {  firstname: "Some",
                                                    lastname: "Body" } }
      assert_forbidden
      assert_equal_attributes User.find(@student.id), { firstname: user_firstname,
                                                        lastname:  user_lastname}
    end

    should "be able to update own information" do
      put user_path(@teacher), params: { user: {  firstname: "Some",
                                                  lastname:  "Body" }}
      assert flash[:success]
      assert_redirected_to preferences_path
      assert_equal_attributes User.find(@teacher.id), { firstname: "Some",
                                                        lastname:  "Body"}
    end

    should "not be able to change into admin" do
      assert_no_difference "User.where(admin: true).count" do
        put user_path(@teacher), params: { user: {  firstname: "Some",
                                                    lastname:  "Body",
                                                    admin:     true }}
      end
      assert flash[:success]
      assert_redirected_to preferences_path
      assert_equal_attributes User.find(@teacher.id), { firstname: "Some",
                                                        lastname:  "Body"}
      assert_not @teacher.admin
    end
  end
  
end
