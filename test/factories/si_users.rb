FactoryGirl.define do
  factory :si_user, :class => SiNationalCoordinator do
    role 'National Coordinator'
    association :user, :factory => :josh_user
  end
end
