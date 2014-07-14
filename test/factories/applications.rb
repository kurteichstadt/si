FactoryGirl.define do
  factory :application, class: Fe::Application do
    association   :applicant
    si_year       2014
  end
end
