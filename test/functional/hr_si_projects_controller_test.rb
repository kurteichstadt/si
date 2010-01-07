require 'test_helper'

class HrSiProjectsControllerTest < ActionController::TestCase
  def setup
    @project = Factory(:hr_si_project)
  end
  
  test "index" do
    cas_login
    get :index
    assert_response :success, @response.body
  end
  
  test "new" do
    cas_login
    get :new
    assert_response :success, @response.body
  end
  
  test "edit" do
    cas_login
    get :edit, :id => @project
    assert_response :success, @response.body
  end
  
  test "show" do
    get :show, :id => @project.id.to_s
    assert_response :success, @response.body
  end
  
  test "projects feed" do
    get :projects_feed, :contry => 'USA'
    assert_response :success, @response.body
  end
  
  test "create" do
    cas_login
    post :create, :hr_si_project => @project.attributes
    assert_redirected_to hr_si_projects_path
  end
  
  test "create with missing data" do
    cas_login
    post :create, :hr_si_project => {}
    assert_response :success, @response.body
  end
  
  test "update" do
    cas_login
    post :update, :id => @project, :hr_si_project => @project.attributes
    assert_redirected_to hr_si_projects_path
  end
  
  test "update with missing data" do
    cas_login
    post :update, :id => @project, :hr_si_project => {:name => ''}
    assert_response :success, @response.body
  end
  
  test "get_valid_projects" do
    login
    setup_application
    post :get_valid_projects
    assert_response :success, @response.body
  end
  
  
end
