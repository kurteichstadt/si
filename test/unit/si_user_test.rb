require 'test_helper'

class SiUserrTest < ActiveSupport::TestCase

  test "region" do
    @person = Factory(:person, :region => 'SW')
    @user = @person.user
    @si_user = Factory(:si_user, :user => @user)
    assert_equal('SW', @si_user.region)
  end
end
