FactoryGirl.define do
  factory :apply do
    #association   :sleeve
    association   :applicant, :factory => :person
    status        'started'
  end
end
