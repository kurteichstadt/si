FactoryGirl.define do
  factory :ref_question_sheet, :parent => :question_sheet do
    sequence(:label) {|n| "Reference#{n}" }
  end
end
