require 'test_helper'

class NotifierTest < ActiveSupport::TestCase

  test "choices" do
    assert Fe::StateChooser.new.choices.length > 0
  end
end
