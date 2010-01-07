require 'test_helper'

class SubmitPagesControllerTest < ActionController::TestCase
  
 def setup
    login
    setup_application
    setup_reference
  end
  
  test "edit" do
    get :edit, :application_id => @apply
    assert_response :success, @response.body
  end
  
  test "update" do
    put :update, :application_id => @apply
    assert_response :success, @response.body
  end
  
  test "submit without payment" do
    post :submit, :application_id => @apply
    assert_response :success, @response.body
    assert(application = assigns(:application), "Cannot find @application")
    assert_equal(1, application.errors.length)
  end
  
  test "submit with payment" do
    Factory(:payment, :apply => @apply)
    assert_difference "ActionMailer::Base.deliveries.length", 8 do
      post :submit, :application_id => @apply
    end
    assert_response :success, @response.body
    assert(application = assigns(:application), "Cannot find @application")
    assert_equal(0, application.errors.length)
    assert_response :success, @response.body
  end
  
end
