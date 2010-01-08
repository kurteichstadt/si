require 'test_helper'

class ElementTest < ActiveSupport::TestCase

  test "limit" do
    @person = Factory(:person)
    setup_application
    element = Factory(:element, :object_name => 'applicant', :attribute_name => 'firstName', :page => @page, :question_sheet => @question_sheet)
    assert_equal(50, element.limit(@apply))
  end
end
