require 'test_helper'

class SiUserrTest < ActiveSupport::TestCase

  test "region" do
    @person = create(:person, :region => 'SW')
    @user = @person.user
    @si_user = create(:si_user, :user => @user)
    assert_equal('SW', @si_user.region)
  end
end
