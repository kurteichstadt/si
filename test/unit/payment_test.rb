require 'test_helper'

class PaymentTest < ActiveSupport::TestCase

  test "staff payment" do
    payment = Payment.new(:payment_type => 'Staff')
    assert(payment.staff?, "Should be a staff payment.")
  end
end
