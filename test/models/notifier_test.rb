require 'test_helper'

class NotifierTest < ActiveSupport::TestCase

  test "raises error if template is missing" do
    assert_raise(RuntimeError) { 
      Fe::Notifier.notification('asdf','asdf','asdf',{}).deliver
    }
  end
end
