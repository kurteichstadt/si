FactoryGirl.define do
  factory :hr_si_project do
    sequence(:name)     { |n| "Test Project#{n}" }
    partnershipRegion   'SW'
    city                'Here'
    country             'USA'
    displayLocation     'Italy:Rome'
    projectType         's'
    studentStartDate    3.days.from_now
    studentEndDate      1.month.from_now
    siYear              HrSiApplication::YEAR
  end
end