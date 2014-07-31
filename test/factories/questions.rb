FactoryGirl.define do
  factory :question, class: 'Fe::Question' do
    sequence(:label)    {|n| "Question #{n}" }
    sequence(:position) { |n| n }
    #association         :page_elements
  end

  factory :ref_question, :parent => :question do
    kind 'Fe::ReferenceQuestion'
    # app/controllers/fe/applications_controller.rb expects the reference question sheet id to be 2
    related_question_sheet_id { Fe::QuestionSheet.where(id: 2).first || create(:ref_question_sheet, id: 2).id }
  end
end
