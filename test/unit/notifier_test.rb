require 'test_helper'

class NotifierTest < ActiveSupport::TestCase

  test "raises error if template is missing" do
    assert_raise(RuntimeError) { 
      Notifier.deliver_notification('asdf','asdf','asdf',{})
    }
  end
end
