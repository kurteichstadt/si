require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    CAS::Filter.fake = true
    @person = Factory(:person)
    @user = @person.user
    @si_user = Factory(:si_user, :user => @user)
    @request.session[:user_id] = @user.id
  end
  
  test "edit" do
    get :edit, :id => @si_user
    assert_response :success, @response.body 
  end
  
  test "update" do
    put :update, :id => @si_user, :temp_user => @si_user.attributes
    assert(si_user = assigns(:temp_user))
    assert_redirected_to users_path
  end
  
  test "new" do
    get :new
    assert_response :success, @response.body
  end
  
  test "create" do
    assert_difference("SiUser.count", 1) do
      post :create, :person_id => Factory(:person, :user => Factory(:josh_user)), :temp_user => {:role => 'SiNationalCoordinator'}
    end
    assert si_user = assigns(:temp_user)
    assert_redirected_to users_path
  end
  
  test "create with missing attributes" do
    post :create
    assert si_user = assigns(:temp_user)
    assert(si_user.new_record?)
    assert_response :success, @response.body
  end
  
  test "index" do
    get :index
    assert_response :success, @response.body
    assert(users = assigns(:users), "Cannot find @users")
  end
  
  test "destroy" do
    assert_difference("SiUser.count", -1) do
      delete :destroy, :id => @si_user
    end
    assert_redirected_to users_path
  end
  
  test "search first name" do
    post :search, :name => 'josh'
    assert_response :success, @response.body
  end
  
  test "search full name" do
    post :search, :name => 'josh starcher'
    assert_response :success, @response.body
  end
  
end
