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
  end
end
