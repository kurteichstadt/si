FactoryGirl.define do
  factory :staff_payment, :parent => :payment do
    payment_type        'Staff'
    payment_account_no  '000559826'
  end
end
