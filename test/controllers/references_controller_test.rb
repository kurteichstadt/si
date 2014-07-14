require 'test_helper'

class ReferencesControllerTest < ActionController::TestCase
  def setup
    login
    setup_application
    setup_reference
  end
  
  test 'edit' do
    get :edit, :application_id => @application, :id => @reference.access_key
    assert_redirected_to edit_reference_sheet_path(@reference, :a => @reference.access_key)
  end
  #
  #test 'send invite' do
  #  assert_difference 'ActionMailer::Base.deliveries.length', 2 do
  #    xhr :post, :send_invite, :application_id => @application, :id => @reference, "references"=>{ @reference.id =>{"name"=>"Josh Starcher", "months_known"=>"3", "phone"=>"+1-800-555-1234 x102", "email"=>"josh.starcher@gmail.com"}}
  #  end
  #end
  #
  #test 'submit' do
  #  assert_difference 'ActionMailer::Base.deliveries.length', 2 do
  #    xhr :post, :submit, :application_id => @application, :id => @reference
  #  end
  #  assert_response :success, @response.body
  #end

end
