#require 'test_helper'
#
#class SleeveSheetsControllerTest < ActionController::TestCase
#  def setup
#    cas_login
#    @sleeve_sheet = create(:sleeve_sheet)
#  end
#
#  test "show" do
#    get :show, :id => @sleeve_sheet, :sleeve_id => @sleeve_sheet.sleeve.id
#    assert_response :success, @response.body
#  end
#
#  test "edit" do
#    get :edit, :id => @sleeve_sheet, :sleeve_id => @sleeve_sheet.sleeve.id
#    assert_response :success, @response.body
#  end
#
#  test "update" do
#    put :update, :id => @sleeve_sheet, :sleeve_id => @sleeve_sheet.sleeve.id, :sleeve_sheet => @sleeve_sheet.attributes
#    assert(sleeve_sheet = assigns(:sleeve_sheet))
#    assert_equal(0, sleeve_sheet.errors.length)
#  end
#
#  test "update with bad attributes" do
#    put :update, :id => @sleeve_sheet, :sleeve_id => @sleeve_sheet.sleeve.id, :sleeve_sheet => {:title => ''}
#    assert(sleeve_sheet = assigns(:sleeve_sheet))
#    assert_equal(1, sleeve_sheet.errors.length)
#  end
#
#  test "create" do
#    assert_difference("SleeveSheet.count", 1) do
#      post :create, :sleeve_id => @sleeve_sheet.sleeve.id, :sleeve_sheet => Factory.attributes_for(:sleeve_sheet).merge(:question_sheet_id => @sleeve_sheet.question_sheet.id)
#    end
#    assert sleeve_sheet = assigns(:sleeve_sheet)
#    assert_equal(0, sleeve_sheet.errors.length)
#  end
#
#  test "create with missing attributes" do
#    post :create, :sleeve_id => @sleeve_sheet.sleeve.id, :sleeve_sheet => {}
#    assert sleeve_sheet = assigns(:sleeve_sheet)
#    assert(sleeve_sheet.new_record?)
#    assert_response :success, @response.body
#  end
#
#  test "destroy" do
#    assert_difference("SleeveSheet.count", -1) do
#      delete :destroy, :sleeve_id => @sleeve_sheet.sleeve.id, :id => @sleeve_sheet
#    end
#    assert_response :success, @response.body
#  end
#
#
#end
