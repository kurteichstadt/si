require 'test_helper'

class NotifierTest < ActiveSupport::TestCase

  test "choices" do
    assert StateChooser.new.choices.length > 0
  end
end
