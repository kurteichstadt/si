FactoryGirl.define do
  factory :question, class: 'Fe::Question' do
    sequence(:label)    {|n| "Question #{n}" }
    sequence(:position) { |n| n }
    #association         :page_elements
  end

  factory :ref_question, :parent => :question do
    kind 'Fe::ReferenceQuestion'
    related_question_sheet_id { create(:ref_question_sheet).id }
  end
end
