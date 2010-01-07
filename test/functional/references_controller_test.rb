require 'test_helper'

class ReferencesControllerTest < ActionController::TestCase
  def setup
    login
    setup_application
    setup_reference
  end
  
  test "edit" do
    get :edit, :application_id => @apply, :id => @reference.token
    assert_response :success, @response.body
  end
  
  test "send invite" do
    assert_difference 'ActionMailer::Base.deliveries.length', 2 do
      post :send_invite, :application_id => @apply, :id => @reference, "references"=>{ @reference.sleeve_sheet_id =>{"name"=>"Josh Starcher", "months_known"=>"3", "phone"=>"+1-800-555-1234 x102", "email"=>"josh.starcher@gmail.com"}}
    end
  end
  
  test "submit" do
    assert_difference 'ActionMailer::Base.deliveries.length', 2 do
      post :submit, :application_id => @apply, :id => @reference
    end
    assert_response :success, @response.body
  end

end
