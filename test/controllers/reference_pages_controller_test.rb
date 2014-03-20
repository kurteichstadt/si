require 'test_helper'

class ReferencePagesControllerTest < ActionController::TestCase
  
 def setup
    login
    setup_application
    @ref_sheet = create(:reference)
  end
  
  test "edit" do
    get :edit, :application_id => @apply
    assert_response :success, @response.body
  end
  
  test "update" do
    put :update, :application_id => @apply, :references => {}
    assert_response :success, @response.body
  end
  
end
