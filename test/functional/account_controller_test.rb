require 'test_helper'

class AccountControllerTest < ActionController::TestCase
  
  test "index" do
    get :index
    assert_redirected_to :action => "login"
  end
  
  test "get login" do
    get :login
    assert_response :success, @response.body
  end
  
  test "post good login" do
    user = Factory(:user)
    post :login, :username => user.username, :password => user.plain_password
    assert_redirected_to :controller => 'applications', :action => 'show_default'
  end
  
  test "post failed login" do
    user = Factory(:user)
    post :login, :username => user.username, :password => 'wrong password'
    assert_response :success, @response.body
  end
  
end
