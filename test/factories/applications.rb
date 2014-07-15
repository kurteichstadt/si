FactoryGirl.define do
  factory :application, class: Fe::Application do
    association   :applicant, factory: :person
    si_year       2014
  end
end
