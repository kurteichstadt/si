require 'test_helper'

class Fe::ApplicationsControllerTest < ActionController::TestCase
  
  def setup
    Fe::Element.delete_all
    login
    setup_application
  end
  
  test "index" do
    get :index
    assert_redirected_to :action => "show_default"
  end
  
  test "show default" do 
    setup_reference
    get :show_default
    assert_response :success, @response.body
  end
  
  test "show default no application" do 
    setup_reference_question_sheets
    @person.application.destroy
    get :show_default
    assert_response :success, @response.body
  end
  
  test "create" do
    post :create, :question_sheet_id => @question_sheet.id
    assert(application = assigns(:application), "Cannot find @application")
    assert_redirected_to fe_application_path(application)
  end
  
  test "create missing attributes" do
    post :create, :question_sheet_id => @question_sheet.id
    assert(application = assigns(:application), "Cannot find @application")
    assert_redirected_to fe_application_path(application)
  end
  
  test "edit" do
    setup_reference
    get :edit, :id => @application
    assert_response :success, @response.body
  end
  
  test "edit other person's application" do
    @app = create(:application, :applicant => create(:josh))
    get :edit, :id => @app
    assert_redirected_to '/'
  end
  
  #test "show" do
  #  cas_login
  #  get :show, :id => @application
  #  assert_response :success, @response.body
  #  assert_template :show
  #end
  #
  #test "show with no answer sheets" do
  #  cas_login
  #  get :show, :id => @application
  #  assert_response :success, @response.body
  #  assert_template :too_old
  #end
  #
  #test "no ref" do
  #  cas_login
  #  get :no_ref, :id => @application
  #  assert_response :success, @response.body
  #  assert_template :show
  #end
  #
  #test "no ref with no answer sheets" do
  #  cas_login
  #  get :no_ref, :id => @application
  #  assert_response :success, @response.body
  #  assert_template :too_old
  #end
  #
  #test "no conf" do
  #  cas_login
  #  get :no_conf, :id => @application
  #  assert_response :success, @response.body
  #  assert_template :show
  #end
  #
  #test "no conf with no answer sheets" do
  #  cas_login
  #  get :no_conf, :id => @application
  #  assert_response :success, @response.body
  #  assert_template :too_old
  #end
  
  test "collated refs" do
    setup_reference
    cas_login
    get :collated_refs, :id => @application.id
    assert_response :success, @response.body
    assert_template :collated_refs
  end
  
  test "collated refs with no answer sheets" do
    setup_reference_question_sheets
    cas_login
    get :collated_refs, :id => @application
    assert_response :success, @response.body
    assert_template :too_old
  end
  
  test "get year" do
    assert_equal(Fe::Application::YEAR, Fe::ApplicationsController.new.send(:get_year))
  end
  
end
