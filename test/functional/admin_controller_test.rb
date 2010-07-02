require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  def setup
    cas_login
  end
  
  test "index" do
    get :index
    assert_response :success, @response.body
  end
  
  test "ssl test" do
    get :ssl_test
    assert_response :success, @response.body
    assert_match(/false/, @response.body)
  end
  
  test "logout" do
    get :logout
    assert_redirected_to "https://signin.ccci.org/cas/logout"
  end
  
  test "select region with no region" do
    post :select_region
    assert_redirected_to :action => "index"
  end
  
  test "select region - unassigned" do
    login
    setup_application
    setup_reference
    post :select_region, :region => ''
    assert_response :success, @response.body
  end
  
end
