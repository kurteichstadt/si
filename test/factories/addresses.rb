FactoryGirl.define do
  factory :address do
    association :person
    email       'test@example.com'
    homePhone   '555-555-5555'
    addressType 'current'
  end
end
