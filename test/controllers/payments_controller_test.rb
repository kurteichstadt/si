require 'test_helper'


class PaymentsControllerTest < ActionController::TestCase
  
 def setup
    login
    setup_application
    create(:staff)
  end
  
  def setup_payment
    cas_login
    @payment = create(:staff_payment, :answer_sheet => @application)
  end
  
  #test "credit card payment" do
  #  response = mock('response')
  #  response.stubs(:success?).returns(true)
  #  # response.stubs(:authorization).returns(true)
  #
  #  ActiveMerchant::Billing::AuthorizeNetGateway.any_instance.stubs(:purchase).returns(response)
  #
  #  post :create, :application_id => @application, "payment"=>{"city"=>"Villa Park", "address"=>"123 Somewhere St", "zip"=>"60181", "card_type"=>"visa", "security_code"=>"123", "expiration_year"=> Time.now.year, "card_number"=>"4111111111111111", "expiration_month"=> Time.now.month + 1, "last_name"=>"Joe", "state"=>"CA", "first_name"=>"GI", "payment_type"=>"Credit Card"}
  #  assert(payment = assigns(:payment))
  #  assert_equal([], payment.errors.full_messages)
  #  assert_response :success, @response.body
  #end
  #
  #test "transaction failed" do
  #  response = mock
  #  response.stubs(:success?).returns(false)
  #  response.stubs(:message).returns('Transaction failed')
  #
  #  ActiveMerchant::Billing::AuthorizeNetGateway.any_instance.stubs(:purchase).returns(response)
  #  assert_difference 'ActionMailer::Base.deliveries.length', 1 do
  #    post :create, :application_id => @application, "payment"=>{"city"=>"Villa Park", "address"=>"123 Somewhere St", "zip"=>"60181", "card_type"=>"visa", "security_code"=>"123", "expiration_year"=> Time.now.year, "card_number"=>"4111111111111111", "expiration_month"=> Time.now.month + 1, "last_name"=>"Joe", "state"=>"CA", "first_name"=>"GI", "payment_type"=>"Credit Card"}
  #  end
  #  assert(payment = assigns(:payment))
  #  assert_equal(["Credit card transaction failed: Transaction failed"], payment.errors.full_messages)
  #  assert_response :success, @response.body
  #end
  
  test "bad credit card" do
    xhr :post, :create, :application_id => @application, "payment"=>{"city"=>"Villa Park", "address"=>"123 Somewhere St", "zip"=>"60181", "card_type"=>"visa", "security_code"=>"123", "expiration_year"=> Time.now.year, "card_number"=>"4111111111111112", "expiration_month"=> Time.now.month + 1, "last_name"=>"Joe", "state"=>"CA", "first_name"=>"GI", "payment_type"=>"Credit Card"}
    assert(payment = assigns(:payment))
    assert_equal(["Card number is invalid.  Check the number and/or the expiration date."], payment.errors.full_messages)
    assert_response :success, @response.body
  end
  
  test "double paying" do
    create(:email_template)
     @application.payments.create(:payment_type => 'Staff', :payment_account_no => '000559826', :staff_first => 'John', :staff_last => 'Doe')
    xhr :post, :create, :application_id => @application, :payment => {:payment_type => 'Staff', :payment_account_no => '000559826', :staff_first => 'John', :staff_last => 'Doe'}
    assert_template 'error'
  end
  
  test "staff payment" do
    create(:email_template)
    xhr :post, :create, :application_id => @application, :payment => {:payment_type => 'Staff', :payment_account_no => '000559826', :staff_first => 'John', :staff_last => 'Doe'}
    assert_response :success, @response.body
  end
  
  test "mail payment" do
    create(:email_template)
    xhr :post, :create, :application_id => @application, :payment => {:payment_type => 'Mail'}
    assert_response :success, @response.body
  end
  
  test "edit" do
    setup_payment
    get :edit, :id => @payment, :application_id => @application
    assert_response :success, @response.body
  end
  
  test "edit non-Staff payment" do
    cas_login
    @payment = create(:payment, :answer_sheet => @application)
    get :edit, :id => @payment, :application_id => @application
    assert_template "no_access"
  end
  
  test "update Approve payment" do
    setup_payment
    #assert_difference 'ActionMailer::Base.deliveries.length', 2 do
      put :update, :id => @payment, :application_id => @application, :payment => {:status => 'Other Account'}, :other_account => '000000000'
    #end
    assert(payment = assigns(:payment), "Cannot find @payment")
    assert(payment.approved?, "Payment wasn't approved")
    assert_response :success, @response.body
  end
  
  test "update Decline payment" do
    setup_payment
    #assert_difference 'ActionMailer::Base.deliveries.length', 1 do
      put :update, :id => @payment, :application_id => @application, :payment => {:status => 'Declined'}
    #end
    assert(payment = assigns(:payment), "Cannot find @payment")
    assert(!payment.approved?)
    assert_response :success, @response.body
  end
  
  test "destroy" do
    setup_payment
    assert_difference "Fe::Payment.count", -1 do
      xhr :delete, :destroy, :id => @payment, :application_id => @application
    end
    assert_response :success, @response.body
  end

end
