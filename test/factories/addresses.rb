FactoryGirl.define do
  factory :address, class: Fe::Address do
    association :person
    email       'test@example.com'
    home_phone   '555-555-5555'
    address_type 'current'
  end
end
