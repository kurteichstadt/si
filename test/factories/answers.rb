FactoryGirl.define do
  factory :answer do
    association :answer_sheet
    association :question
    value       'long foo'
    short_value 'foo'
  end
end