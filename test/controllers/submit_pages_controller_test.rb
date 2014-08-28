require 'test_helper'

module Fe
  class SubmitPagesControllerTest < ActionController::TestCase

    def setup
      login
      setup_application
      setup_reference
    end

    test "edit" do
      xhr :get, :edit, :application_id => @application
      assert_response :success, @response.body
    end

    test "update" do
      xhr :put, :update, :application_id => @application
      assert_response :success, @response.body
    end

    test "submit without payment" do
      xhr :post, :submit, :application_id => @application
      assert_response :success, @response.body
      assert(application = assigns(:application), "Cannot find @application")
      assert_equal(1, application.errors.messages.length)
    end

    test "submit with payment" do
      create(:payment, :application => @application)
      #assert_difference "ActionMailer::Base.deliveries.length", 8 do
      create(:email_template, name: "Application Submitted")
      create(:email_template, name: "Reference Invite")
      create(:email_template, name: "Reference Notification")
      create(:email_template, name: "Reference Notification to Applicant")
      xhr :post, :submit, :application_id => @application
      #end
      assert_response :success, @response.body
      assert(application = assigns(:application), "Cannot find @application")
      assert_equal(0, application.errors.count)
      assert_response :success, @response.body
    end

  end
end
