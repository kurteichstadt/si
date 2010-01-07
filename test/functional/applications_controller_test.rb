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
    assert_template :show
  end
  
  test "show with no answer sheets" do
    @apply.apply_sheets.collect(&:destroy)
    @sleeve.sleeve_sheets.collect(&:destroy)
    cas_login
    get :show, :id => @apply
    assert_response :success, @response.body
    assert_template :too_old
  end
  
  test "no ref" do
    cas_login
    get :no_ref, :id => @apply
    assert_response :success, @response.body
    assert_template :show
  end
  
  test "no ref with no answer sheets" do
    @apply.apply_sheets.collect(&:destroy)
    @sleeve.sleeve_sheets.collect(&:destroy)
    cas_login
    get :no_ref, :id => @apply
    assert_response :success, @response.body
    assert_template :too_old
  end
  
  test "no conf" do
    cas_login
    get :no_conf, :id => @apply
    assert_response :success, @response.body
    assert_template :show
  end
  
  test "no conf with no answer sheets" do
    @apply.apply_sheets.collect(&:destroy)
    @sleeve.sleeve_sheets.collect(&:destroy)
    cas_login
    get :no_conf, :id => @apply
    assert_response :success, @response.body
    assert_template :too_old
  end
  
  test "collated refs" do
    setup_reference
    
    cas_login
    get :collated_refs, :id => @apply
    assert_response :success, @response.body
    assert_template :collated_refs
  end
  
  test "collated refs with no answer sheets" do
    @apply.apply_sheets.collect(&:destroy)
    @sleeve.sleeve_sheets.collect(&:destroy)
    cas_login
    get :collated_refs, :id => @apply
    assert_response :success, @response.body
    assert_template :too_old
  end
  
  test "no access" do
    get :no_access
    assert_redirected_to :action => "login", :controller => :account
  end
end
