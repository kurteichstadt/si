FactoryGirl.define do
  factory :email_template, class: 'Fe::EmailTemplate' do
    name          'Staff Payment Request'
    content       '{{ staff_full_name }} send money to {{applicant_full_name}} contact {{ applicant_email }} {{ applicant_home_phone }} {{ payment_request_url }}'
    subject       'Application Payment Request for {{ applicant_full_name }}'
  end
end