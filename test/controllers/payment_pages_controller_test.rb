require 'test_helper'

class PaymentPagesControllerTest < ActionController::TestCase
  
 def setup
    login
    setup_application
  end
  
  test "staff search" do
    xhr :post, :staff_search, :application_id => @apply, :payment => {:staff_first => 'Josh', :staff_last => 'Starcher'}
    assert_response :success, @response.body
  end
  
  test 'blank staff search' do
    xhr :post, :staff_search, :application_id => @apply, :payment => {:staff_first => '', :staff_last => ''}
    assert_response :success, @response.body
  end
  
end
