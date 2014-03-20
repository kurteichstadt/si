require 'test_helper'

class AccountControllerTest < ActionController::TestCase
  
  #test "index" do
  #  get :index
  #  assert_redirected_to :action => "login"
  #end
  
  #test "get login" do
  #  get :login
  #  assert_response :success, @response.body
  #end
  
  #test "post good login" do
  #  user = create(:user)
  #  post :login, :username => user.username, :password => user.plain_password, :remember_me => '1'
  #  assert_redirected_to :controller => 'applications', :action => 'show_default'
  #end
  #
  #test "post failed login" do
  #  user = create(:user)
  #  post :login, :username => user.username, :password => 'wrong password'
  #  assert_response :success, @response.body
  #end
  #
  ##test "get signup" do
  ##  get :signup
  ##  assert_response :success, @response.body
  ##end
  #
  #test "post signup" do
  #  post :signup, :user => {:username => 'foo@example.com', :password => 'asdfASDF33'}, :person => {:firstName => 'Bob', :lastName => 'Dole'}
  #  assert_redirected_to :action => "login"
  #end
  #
  #test "post signup missing name" do
  #  post :signup, :user => {:username => 'foo@example.com', :password => 'asdfASDF33'}, :person => {}
  #  assert_response :success, @response.body
  #  assert(person = assigns(:person), "Cannot find @person")
  #  assert_equal(2, person.errors.length)
  #  assert(user = assigns(:user), "Cannot find @user")
  #  assert_equal(1, user.errors.length)
  #end
  #
  #test "logout" do
  #  get :logout
  #  assert_redirected_to :action => "login"
  #end
  #
  #test "secret hooey" do
  #  get :secret_hooey
  #  assert_response :success, @response.body
  #end
  
end
