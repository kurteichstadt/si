FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "test.user#{n}@uscm.org" }
    plain_password 'asAfasfsd'
    plain_password_confirmation 'asAfasfsd'
    secret_question 'asdfsad'
    secret_answer 'asdfdasf'
  end

  factory :josh_user, :parent => :user do
    sequence(:globallyUniqueID) { |n| "F167605D-94A4-7121-2A58-8D0F2CA6E026#{n}" }
  end
end

