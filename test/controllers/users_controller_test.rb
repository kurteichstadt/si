require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @person = create(:person)
    @user = @person.user
    @request.session[:cas_user] = @user.username
    @si_user = create(:si_user, :user => @user, :type => 'SiNationalCoordinator')
    @request.session[:user_id] = @user.id
  end
  
  test "edit" do
    get :edit, :id => @si_user
    assert_response :success, @response.body 
  end
  
  test "update" do
    create(:role, :user_class => @si_user.type)
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
      create(:role, :user_class => "SiNationalCoordinator")
      post :create, :person_id => create(:person, :user => create(:josh_user)), :temp_user => {:role => 'SiNationalCoordinator'}
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
    xhr :post, :search, :name => 'josh'
    assert_response :success, @response.body
  end
  
  test "search full name" do
    xhr :post, :search, :name => 'josh starcher'
    assert_response :success, @response.body
  end
  
end
