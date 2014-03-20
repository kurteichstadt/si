#require 'test_helper'
#
#class SleevesControllerTest < ActionController::TestCase
#  def setup
#    cas_login
#  end
#
#  test "edit with sheets" do
#    sleeve = create(:sleeve)
#    sleeve_sheet = create(:sleeve_sheet, :sleeve => sleeve)
#    get :edit, :id => sleeve
#    assert_response :success, @response.body
#  end
#
#  test "update" do
#    sleeve = create(:sleeve)
#    put :update, :id => sleeve, :sleeve => {:title => 'foo'}
#    assert(sleeve = assigns(:sleeve))
#    assert_equal('foo', sleeve.title)
#    assert_redirected_to sleeves_path
#  end
#
#  test "update with bad attributes" do
#    sleeve = create(:sleeve)
#    put :update, :id => sleeve, :sleeve => {:title => ''}
#    assert(sleeve = assigns(:sleeve))
#    assert_not_equal([], sleeve.errors.full_messages)
#    assert_response :success, @response.body
#  end
#
#  test "new" do
#    get :new
#    assert_response :success, @response.body
#  end
#
#  test "create" do
#    post :create, :sleeve => Factory.attributes_for(:sleeve)
#    assert sleeve = assigns(:sleeve)
#    assert_redirected_to edit_sleeve_path(sleeve)
#  end
#
#  test "create with missing attributes" do
#    post :create, :sleeve => {}
#    assert sleeve = assigns(:sleeve)
#    assert(sleeve.new_record?)
#    assert_response :success, @response.body
#  end
#
#  test "index" do
#    get :index
#    assert_response :success, @response.body
#  end
#
#  test "destroy" do
#    sleeve_sheet = create(:sleeve_sheet)
#    sleeve = sleeve_sheet.sleeve
#    assert_difference("Sleeve.count", -1) do
#      delete :destroy, :id => sleeve
#    end
#    assert_redirected_to sleeves_path
#  end
#
#  test "destroying a sleeve with applicants" do
#    login
#    setup_application
#    assert_no_difference("Sleeve.count") do
#      delete :destroy, :id => @sleeve
#    end
#    assert_response :success, @response.body
#    assert_template :index
#  end
#end
