Factory.define :email_template do |e|
  e.name          'Staff Payment Request'
  e.content       '{{ staff_full_name }} send money to {{applicant_full_name}} contact {{ applicant_email }} {{ applicant_home_phone }} {{ payment_request_url }}'
  e.subject       'Application Payment Request for {{ applicant_full_name }}'
end