require 'test_helper'

class InfoPagesControllerTest < ActionController::TestCase
  
  test "index logged in" do
    login
    get :index
    assert_redirected_to show_default_path
  end
  
  test "index not logged in" do
    get :index
    assert_redirected_to '/info_pages/home'
  end
  
  test "home" do
    get :home
    assert_response :success, @response.body
  end
  
  test "instructions" do
    get :instructions
    assert_response :success, @response.body
  end
  
  test "faqs" do
    create(:element, kind: 'Fe::Paragraph', slug: 'faq')
    get :faqs
    assert_response :success, @response.body
  end
  
  test "about us" do
    get :about_us
    assert_response :success, @response.body
  end
  
  test "contact us" do
    get :contact_us
    assert_response :success, @response.body
  end
  
  test "opportunities" do
    get :opportunities
    assert_response :success, @response.body
  end
  
  test "a real life story" do
    get :a_real_life_story
    assert_response :success, @response.body
  end
  
  test "privacy policy" do
    get :privacy_policy
    assert_response :success, @response.body
  end

end
