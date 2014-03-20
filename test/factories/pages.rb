FactoryGirl.define do
  factory :page, class: 'Fe::Page' do
    association   :question_sheet
    label         'Welcome!'
    number        1
  end
end