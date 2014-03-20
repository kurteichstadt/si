FactoryGirl.define do
  factory :question_sheet, class: 'Fe::QuestionSheet' do
    sequence(:label) {|n| "STINT / Internship Application#{n}" }
  end

  factory :ref_question_sheet, :parent => :question_sheet do
    sequence(:label) {|n| "Reference#{n}" }
  end
end