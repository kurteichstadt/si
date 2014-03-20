FactoryGirl.define do
  factory :reference, class: 'Fe::ReferenceSheet' do
    association :applicant_answer_sheet, factory: :apply
    association :question, factory: :ref_question
    access_key         { Digest::MD5.hexdigest((object_id + Time.now.to_i).to_s) }
    first_name    'Refer'
    last_name     'Me'
    email         'refer@example.com'
    phone         '444-444-4444'
    months_known  '3'
  end
end