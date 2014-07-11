require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase

  def setup
    @ac = ApplicationController.new
  end
  
  test "escape string" do
    assert_equal("a\\\'d", @ac.send(:escape_string, "a'd"))
  end
  
  test "is true" do
    assert(@ac.send(:is_true, 1))
    assert(@ac.send(:is_true, '1'))
    assert(@ac.send(:is_true, 'true'))
    assert(@ac.send(:is_true, true))
  end
  
  test "is false" do
    assert(@ac.send(:is_false, 0))
    assert(@ac.send(:is_false, '0'))
    assert(@ac.send(:is_false, 'false'))
    assert(@ac.send(:is_false, false))
  end
  
  
end
