require 'test_helper'

class EmailTemplatesControllerTest < ActionController::TestCase
  def setup
    cas_login
    @template = Factory(:email_template)
  end
  
  test "edit" do
    get :edit, :id => @template
    assert_response :success, @response.body
  end
  
  test "update" do
    put :update, :id => @template, :email_template => @template.attributes
    assert(etemplate = assigns(:email_template))
    assert_equal(@template.name, etemplate.name)
    assert_redirected_to email_templates_path
  end
  
  test "update with bad attributes" do
    put :update, :id => @template, :email_template => {:name => ''}
    assert(etemplate = assigns(:email_template))
    assert_not_equal([], etemplate.errors.full_messages)
    assert_response :success, @response.body
  end
  
  test "new" do
    get :new
    assert_response :success, @response.body
  end
  
  test "create" do
    assert_difference("EmailTemplate.count", 1) do
      post :create, :email_template => @template.attributes
    end
    assert etemplate = assigns(:email_template)
    assert_redirected_to email_templates_path
  end
  
  test "create with missing attributes" do
    post :create, :email_template => {}
    assert etemplate = assigns(:email_template)
    assert(etemplate.new_record?)
    assert_response :success, @response.body
  end
  
  test "index" do
    get :index
    assert_response :success, @response.body
  end
  
  test "destroy" do
    assert_difference("EmailTemplate.count", -1) do
      delete :destroy, :id => @template
    end
    assert_redirected_to email_templates_path
  end
  
end
