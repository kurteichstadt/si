require 'test_helper'

class ApplicationsControllerTest < ActionController::TestCase
  
  def setup
    login
    setup_application
  end
  
  test "index" do
    get :index
    assert_redirected_to :action => "show_default"
  end
  
  test "show_default" do
    get :show_default
    assert_response :success, @response.body
  end
  
  # test "edit with sheets" do
  #   sleeve = Factory(:sleeve)
  #   sleeve_sheet = Factory(:sleeve_sheet, :sleeve => sleeve)
  #   get :edit, :id => sleeve
  #   assert_response :success, @response.body
  # end
  # 
  # test "update" do
  #   sleeve = Factory(:sleeve)
  #   put :update, :id => sleeve, :sleeve => {:title => 'foo'}
  #   assert(sleeve = assigns(:sleeve))
  #   assert_equal('foo', sleeve.title)
  #   assert_redirected_to sleeves_path
  # end
  # 
  # test "new" do
  #   get :new
  #   assert_response :success, @response.body
  # end
  # 
  # test "create" do
  #   post :create, :sleeve => Factory.attributes_for(:sleeve)
  #   assert sleeve = assigns(:sleeve)
  #   assert_redirected_to edit_sleeve_path(sleeve)
  # end
  # 
  # test "destroy" do
  #   sleeve = Factory(:sleeve)
  #   assert_difference("Sleeve.count", -1) do
  #     delete :destroy, :id => sleeve
  #   end
  #   assert_redirected_to sleeves_path
  # end
end
