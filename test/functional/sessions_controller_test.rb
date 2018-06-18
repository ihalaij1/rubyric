require 'test_helper'

class SessionsControllerTest < ActionController::TestCase

  fixtures :users

  should 'not accept non-existing user' do
    post :create, params: { session: { email: 'nobody@example.com', password: 'nobody'} }
    assert_nil current_user
    assert_response :success
  end
  
  should 'not accept invalid password' do
    post :create, params: { session: { email: 'student1@example.com', password: 'invalid'} }
    assert_nil current_user
    assert_response :success
  end
  
  should 'not accept empty password' do
    post :create, params: { session: { email: 'student1@email.com', password: ''} }
    assert_nil current_user
    assert_response :success
  end
  
  should 'not accept missing password' do
    post :create, params: { session: { email: 'student1@example.com'} }
    assert_nil current_user
    assert_response :success
  end
  
  should 'not accept empty email' do
    post :create, params: { session: { email: '', password: 'student1'} }
    assert_nil current_user
    assert_response :success
  end
  
  should 'not accept missing email' do
    post :create, params: { session: { password: 'student1' } }
    assert_nil current_user
    assert_response :success
  end
  
  should 'not accept empty email and password' do
    post :create, params: { session: { email: '', password: ''} }
    assert_nil current_user
    assert_response :success
  end
  
  should 'not accept missing email and password' do
    post :create, params: { session: { remember_me: '0'}}
    assert_nil current_user
    assert_response :success
  end
  
  should 'accept valid password' do
    post :create, params: { session: { email: 'student1@example.com', password: 'student1' } }
    assert user_session = Session.find
    assert_equal users(:student1), user_session.user
    assert_response :redirect
  end
  
  
  # User has been created with studentnumber only and then logs in with shibboleth
  # Attributes should be updated
  should 'update attributes after first login with shibboleth' do
#    @request.env['HTTP_EPPN'] = 'newuser@example.com'
#    @request.env['HTTP_SCHACPERSONALUNIQUECODE'] = '00022'
#    @request.env['HTTP_DISPLAYNAME'] = 'Student'
#    @request.env['HTTP_SN'] = '22'
#    @request.env['HTTP_MAIL'] = 'student22@example.com'
#    @request.env['HTTP_SCHACHOMEORGANIZATION'] = 'example.com'
#    @request.env['HTTP_LOGOUTURL'] = 'http://logout.example.com/'
    
    request.env[SHIB_ATTRIBUTES[:id]] = 'newuser@example.com'
    request.env[SHIB_ATTRIBUTES[:studentnumber]] = '00022'
    request.env[SHIB_ATTRIBUTES[:firstname]] = 'Student'
    request.env[SHIB_ATTRIBUTES[:lastname]] = '22'
    request.env[SHIB_ATTRIBUTES[:email]] = 'student22@example.com'
    request.env[SHIB_ATTRIBUTES[:affiliation]] = 'example.com'
    request.env[SHIB_ATTRIBUTES[:logout]] = 'http://logout.example.com/'

    get :shibboleth
    assert user_session = Session.find
    assert_equal users(:ghost), user_session.user
    assert_response :redirect
    
    # Attributes should be updated
    user = User.find(users(:ghost).id)
    assert_equal 'newuser@example.com', user.login
    assert_equal '00022', user.studentnumber
    assert_equal 'Student', user.firstname
    assert_equal '22', user.lastname
    assert_equal 'student22@example.com', user.email
    assert_equal 'example.com', user.organization.domain
  end
  
  # User logs in for the first time with shibboleth
  # User should be created
  should 'create user after first login with shibboleth' do
#    @request.env['HTTP_EPPN'] = 'newbie@example.com'
#    @request.env['HTTP_SCHACPERSONALUNIQUECODE'] = '00023'
#    @request.env['HTTP_SN'] = '23'
#    @request.env['HTTP_MAIL'] = 'student23@example.com'
#    @request.env['HTTP_SCHACHOMEORGANIZATION'] = 'example.com'
#    @request.env['HTTP_LOGOUTURL'] = 'http://logout.example.com/'

    request.env[SHIB_ATTRIBUTES[:id]] = 'newbie@example.com'
    request.env[SHIB_ATTRIBUTES[:studentnumber]] = '00023'
    request.env[SHIB_ATTRIBUTES[:lastname]] = '23'
    request.env[SHIB_ATTRIBUTES[:email]] = 'student23@example.com'
    request.env[SHIB_ATTRIBUTES[:affiliation]] = 'example.com'
    request.env[SHIB_ATTRIBUTES[:logout]] = 'http://logout.example.com/'
    
    assert_difference('User.count', 1) do 
      get :shibboleth
      assert user_session = Session.find, "Session should exist but it doesn't"
      assert_response :redirect
    end
  end
  
  # Existing user logs in with shibboleth
  # Existing attributes should not be overwritten
  should 'let in with shibboleth' do
#    @request.env['HTTP_EPPN'] = 'shibuser@example.com'
#    @request.env['HTTP_SCHACPERSONALUNIQUECODE'] = '00029'
#    @request.env['HTTP_DISPLAYNAME'] = 'New firstname'
#    @request.env['HTTP_SN'] = 'New lastname'
#    @request.env['HTTP_MAIL'] = 'new-mail@example.com'
#    @request.env['HTTP_SCHACHOMEORGANIZATION'] = 'example.com'
#    @request.env['HTTP_LOGOUTURL'] = 'http://logout.example.com/'

    request.env[SHIB_ATTRIBUTES[:id]] = 'shibuser@example.com'
    request.env[SHIB_ATTRIBUTES[:studentnumber]] = '00029'
    request.env[SHIB_ATTRIBUTES[:firstname]] = 'New firstname'
    request.env[SHIB_ATTRIBUTES[:lastname]] = 'New lastname'
    request.env[SHIB_ATTRIBUTES[:email]] = 'new-mail@example.com'
    request.env[SHIB_ATTRIBUTES[:affiliation]] = 'example.com'
    request.env[SHIB_ATTRIBUTES[:logout]] = 'http://logout.example.com/'
    
    get :shibboleth
    assert user_session = Session.find, "Session should exist but doesn't"
    assert_equal users(:shibuser), user_session.user
    assert_response :redirect
    
    # Existing attributes should not be overwritten
    user = User.find(users(:shibuser).id)
    assert_equal 'shibuser@example.com', user.login
    assert_equal '00021', user.studentnumber
    assert_equal 'Student', user.firstname
    assert_equal '21', user.lastname
    assert_equal 'student21@example.com', user.email
    assert_equal 'example.com', user.organization.domain
  end

  # Commented out for, we might want to create users with same studentnumber
  # User with a reserved studentnumber logs in from another organization
#  should 'not allow to login if studentnumber is reserved' do
#    @request.env['HTTP_EPPN'] = 'somebody@otheruniversity.com'
#    @request.env['HTTP_SCHACPERSONALUNIQUECODE'] = '00021'
#    @request.env['HTTP_DISPLAYNAME'] = 'Somebody'
#    @request.env['HTTP_SN'] = 'Strange'
#    @request.env['HTTP_MAIL'] = 'somebody@example.com'
#    @request.env['HTTP_SCHACHOMEORGANIZATION'] = 'otheruniversity.com'
#    @request.env['HTTP_LOGOUTURL'] = 'http://logout.example.com/'

#    request.env[SHIB_ATTRIBUTES[:id]] = 'somebody@otheruniversity.com'
#    request.env[SHIB_ATTRIBUTES[:studentnumber]] = '00021'
#    request.env[SHIB_ATTRIBUTES[:firstname]] = 'Somebody'
#    request.env[SHIB_ATTRIBUTES[:lastname]] = 'Strange'
#    request.env[SHIB_ATTRIBUTES[:email]] = 'somebody@example.com'
#    request.env[SHIB_ATTRIBUTES[:affiliation]] = 'otheruniversity.com'
#    request.env[SHIB_ATTRIBUTES[:logout]] = 'http://logout.example.com/'
    
#    get :shibboleth
#    assert_nil current_user
#    assert_response :success
#  end
  
  # TODO: logout shibboleth
  
  # TODO: logout traditional
  
  
  # TODO: integration
  # Unauthenticated user tries to access a restricted page
  # Should redirect to login



#   def test_should_logout
#     login_as :quentin
#     get :destroy
#     assert_nil session[:user_id]
#     assert_response :redirect
#   end


end
