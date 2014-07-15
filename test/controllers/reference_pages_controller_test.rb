require 'test_helper'

class Fe::ReferencePagesControllerTest < ActionController::TestCase
  
 def setup
    login
    setup_application
    @ref_sheet = create(:reference)
  end
  
  test "edit" do
    get :edit, :application_id => @application
    assert_response :success, @response.body
  end
  
  test "update" do
    put :update, :application_id => @application, :references => {}
    assert_response :success, @response.body
  end
  
end
