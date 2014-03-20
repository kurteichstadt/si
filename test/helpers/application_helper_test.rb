require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

  #test "date stamp" do
  #  assert_equal('07/07/1982', datestamp(Time.mktime(1982,7,7)))
  #end
  
  test "date stamp with nil date" do
    assert_equal('-', datestamp(nil))
  end
end
