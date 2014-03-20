require 'test_helper'

class CampusesControllerTest < ActionController::TestCase
  
  def setup
    login
    setup_application
  end
  
  test "search" do
    school_picker = create(:school_picker)
    xhr :post, :search, :state => 'CA', dom_id: "school_picker_#{school_picker.id}", id: @apply.id
    assert_response :success, @response.body
  end
  

end
