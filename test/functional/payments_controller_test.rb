require 'test_helper'
require 'mocha'

class PaymentsControllerTest < ActionController::TestCase
  
 def setup
    login
    setup_application
    Factory(:staff)
  end
  
  def setup_payment
    cas_login
    @payment = Factory(:staff_payment, :apply => @apply)
  end
  
  test "credit card payment" do
    response = mock
    response.stubs(:success?).returns(true)
    # response.stubs(:authorization).returns(true)

    ActiveMerchant::Billing::AuthorizeNetGateway.any_instance.stubs(:purchase).returns(response)
    
    post :create, :application_id => @apply, "payment"=>{"city"=>"Villa Park", "address"=>"123 Somewhere St", "zip"=>"60181", "card_type"=>"visa", "security_code"=>"123", "expiration_year"=> Time.now.year, "card_number"=>"4111111111111111", "expiration_month"=> Time.now.month + 1, "last_name"=>"Joe", "state"=>"CA", "first_name"=>"GI", "payment_type"=>"Credit Card"}
    assert(payment = assigns(:payment))
    assert_equal([], payment.errors.full_messages)
    assert_response :success, @response.body
  end
  
  test "transaction failed" do
    response = mock
    response.stubs(:success?).returns(false)
    response.stubs(:message).returns('Transaction failed')

    ActiveMerchant::Billing::AuthorizeNetGateway.any_instance.stubs(:purchase).returns(response)
    assert_difference 'ActionMailer::Base.deliveries.length', 1 do
      post :create, :application_id => @apply, "payment"=>{"city"=>"Villa Park", "address"=>"123 Somewhere St", "zip"=>"60181", "card_type"=>"visa", "security_code"=>"123", "expiration_year"=> Time.now.year, "card_number"=>"4111111111111111", "expiration_month"=> Time.now.month + 1, "last_name"=>"Joe", "state"=>"CA", "first_name"=>"GI", "payment_type"=>"Credit Card"}
    end
    assert(payment = assigns(:payment))
    assert_equal(["Credit card transaction failed: Transaction failed"], payment.errors.full_messages)
    assert_response :success, @response.body
  end
  
  test "bad credit card" do
    post :create, :application_id => @apply, "payment"=>{"city"=>"Villa Park", "address"=>"123 Somewhere St", "zip"=>"60181", "card_type"=>"visa", "security_code"=>"123", "expiration_year"=> Time.now.year, "card_number"=>"4111111111111112", "expiration_month"=> Time.now.month + 1, "last_name"=>"Joe", "state"=>"CA", "first_name"=>"GI", "payment_type"=>"Credit Card"}
    assert(payment = assigns(:payment))
    assert_equal(["Card number is invalid.  Check the number and/or the expiration date."], payment.errors.full_messages)
    assert_response :success, @response.body
  end
  
  test "double paying" do
    Factory(:email_template)
    post :create, :application_id => @apply, :payment => {:payment_type => 'Staff', :payment_account_no => '000559826', :staff_first => 'Josh', :staff_last => 'Starcher'}
    post :create, :application_id => @apply, :payment => {:payment_type => 'Staff', :payment_account_no => '000559826', :staff_first => 'Josh', :staff_last => 'Starcher'}
    assert_template :error
  end
  
  test "staff payment" do
    Factory(:email_template)
    post :create, :application_id => @apply, :payment => {:payment_type => 'Staff', :payment_account_no => '000559826', :staff_first => 'Josh', :staff_last => 'Starcher'}
    assert_response :success, @response.body
  end
  
  test "mail payment" do
    Factory(:email_template)
    post :create, :application_id => @apply, :payment => {:payment_type => 'Mail'}
    assert_response :success, @response.body
  end
  
  test "edit" do
    setup_payment
    get :edit, :id => @payment, :application_id => @apply
    assert_response :success, @response.body
  end
  
  test "edit non-Staff payment" do
    cas_login
    @payment = Factory(:payment, :apply => @apply)
    get :edit, :id => @payment, :application_id => @apply
    assert_redirected_to :action => "no_access", :id => 'sorry'
  end
  
  test "update Approve payment" do
    setup_payment
    assert_difference 'ActionMailer::Base.deliveries.length', 2 do
      put :update, :id => @payment, :application_id => @apply, :payment => {:status => 'Other Account'}, :other_account => '000000000'
    end
    assert(payment = assigns(:payment), "Cannot find @payment")
    assert(payment.approved?, "Payment wasn't approved")
    assert_response :success, @response.body
  end
  
  test "update Decline payment" do
    setup_payment
    assert_difference 'ActionMailer::Base.deliveries.length', 1 do
      put :update, :id => @payment, :application_id => @apply, :payment => {:status => 'Declined'}
    end
    assert(payment = assigns(:payment), "Cannot find @payment")
    assert(!payment.approved?)
    assert_response :success, @response.body
  end
  
  test "destroy" do
    setup_payment
    assert_difference "Payment.count", -1 do
      delete :destroy, :id => @payment, :application_id => @apply
    end
    assert_response :success, @response.body
  end
  
  test "no access" do
    get :no_access, :application_id => @apply
    assert_response :success, @response.body
  end
  
end
