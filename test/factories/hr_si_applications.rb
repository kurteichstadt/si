FactoryGirl.define do
  factory :hr_si_application do
    association   :person
    association   :apply
    si_year       2014
  end
end
