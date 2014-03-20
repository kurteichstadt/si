require 'test_helper'

class ElementTest < ActiveSupport::TestCase

  test "limit" do
    @person = create(:person)
    setup_application
    element = create(:element, :object_name => 'applicant', :attribute_name => 'firstName')
    assert_equal(50, element.limit(@apply))
  end
end
