FactoryGirl.define do
  factory :hr_si_application do
    association   :person
    association   :apply
    siYear        HrSiApplication::YEAR
  end
end