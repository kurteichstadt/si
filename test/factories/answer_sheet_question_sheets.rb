FactoryGirl.define do
  factory :answer_sheet_question_sheet, class: 'Fe::AnswerSheetQuestionSheet' do
    association :question_sheet
    association :answer_sheet, factory: :application
  end
end
