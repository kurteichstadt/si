FactoryGirl.define do
  factory :role, class: SiRole do
    role          'National Coordinator'
    user_class    'SiNationalCoordinator'
  end
end
