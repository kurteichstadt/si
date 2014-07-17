require 'test_helper'

class Fe::AnswerPagesControllerTest < ActionController::TestCase
  def setup
    login
    setup_application
    setup_reference
  end
  
  test "edit applicant page" do
    get :edit, :answer_sheet_id => @answer_sheet.id, :id => @page
    assert_response :success, @response.body
  end
  
  test "edit reference page" do
    get :edit, :answer_sheet_id => @ref_answer_sheet.id, :id => @ref_page, :a => @ref_answer_sheet.access_key
    assert_response :success, @response.body
  end
  
end
