require 'test_helper'

class ApplicationsControllerTest < ActionController::TestCase
  
  def setup
    login
    setup_application
  end
  
  test "index" do
    get :index
    assert_redirected_to :action => "show_default"
  end
  
  test "show default" do 
    get :show_default
    assert_response :success, @response.body
  end
  
  test "create" do
    post :create, :sleeve_id => @sleeve
    assert(application = assigns(:application), "Cannot find @application")
    assert_redirected_to application_path(application)
  end
  
  test "edit" do
    get :edit, :id => @apply
    assert_response :success, @response.body
  end
  
  test "show" do
    cas_login
    get :show, :id => @apply
    assert_response :success, @response.body
  end
  
  test "show with no answer sheets" do
    @apply.apply_sheets.collect(&:destroy)
    @sleeve.sleeve_sheets.collect(&:destroy)
    cas_login
    get :show, :id => @apply
    assert_response :success, @response.body
    assert_template :too_old
  end
end
