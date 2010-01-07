require 'test_helper'

class CampusesControllerTest < ActionController::TestCase
  
  def setup
    login
    setup_application
  end
  
  test "search" do
    post :search, :state => 'CA'
    assert_response :success, @response.body
  end
  

end
