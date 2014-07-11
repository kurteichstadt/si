FactoryGirl.define do
  factory :payment, class: 'Fe::Payment' do
    association   :answer_sheet, factory: :apply
    payment_type  'Mail'
    amount        35.0
    status        'Pending'
  end

  factory :staff_payment, :parent => :payment do
    payment_type        'Staff'
    payment_account_no  '000559826'
  end
end
