FactoryGirl.define do
  factory :staff do
    sequence(:accountNo) { |n| " 00055982#{n}" }
    firstName   'Bob'
    lastName    'Staffer'
    email       'bob.staffer@uscm.org'
  end
end
