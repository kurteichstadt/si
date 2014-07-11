FactoryGirl.define do
  factory :person do
    firstName   'GI'
    lastName    'Joe'
    association :user
  end

  factory :josh, :parent => :person do
    firstName   'Josh'
    lastName    'Starcher'
    association :user, :factory => :josh_user
  end
end
