require 'test_helper'

class PaymentPagesControllerTest < ActionController::TestCase
  
 def setup
    login
    setup_application
  end
  
  test "edit" do
    get :edit, :application_id => @apply
    assert_response :success, @response.body
  end
  
  test "update" do
    put :update, :application_id => @apply, :last_name => 'boo'
    assert_response :success, @response.body
  end
  
  test "staff search" do
    post :staff_search, :application_id => @apply, :payment => {:staff_first => 'Josh', :staff_last => 'Starcher'}
    assert_response :success, @response.body
  end
  
  test "blank staff search" do
    post :staff_search, :application_id => @apply, :payment => {:staff_first => '', :staff_last => ''}
    assert_response :success, @response.body
  end
  
end
