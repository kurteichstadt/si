class InsertEmailTemplates < ActiveRecord::Migration
  def self.up
    EmailTemplate.create(:name => "Applicant Staff Payment Receipt",
                         :content => "Dear {{ applicant_full_name }},\n\nA staff member has just paid for your application via account transfer.\n\nThank you very much.\n\nSincerely,\nCampus Crusade for Christ",
                         :subject => "Application Payment Notification")
    EmailTemplate.create(:name => "Tool Owner Payment Confirmation",
                         :content => "To whom it may concern:\n\nTake: {{ payment_amount }}\nFrom: {{ payment_account_no }}\nAuthorized by: {{ payment_auth_code }}\nPayment record ID: {{ payment_id }}\n\nSincerely,\nCampus Crusade for Christ",
                         :subject => "Application Payment Notification")
    EmailTemplate.create(:name => "Payment Refusal",
                         :content => "Dear {{ applicant_full_name }},\n\nThe staff member you requested payment from for your Application has just notified us of their refusal to pay.  Please contact them or make other payment arrangements.  You can log onto the system and pay via credit card or check/money order.\n\nSorry for the inconvenience...  Please remember your application will not be processed until the fee is paid.\n\nSincerely,\nCampus Crusade for Christ",
                         :subject => "Application Payment Notification")
    EmailTemplate.create(:name => "Reference Notification to Applicant",
                         :content => "Dear {{ applicant_full_name }}:\n\nThis email is to notify you that we have sent an email on your behalf to {{ reference_full_name }} inviting him or her to submit a reference for your participation in a  STINT or Internship.  The email was sent to: {{ reference_email }}.  If the email address is invalid or the message is returned for any reason, you will receive the returned email.  If this happens, 1) please login to your STINT/Internship application, 2) go to the References page, 3) correct the reference's email address, and 4) click the 'Send Email Invitation' button.\n\nTo make any changes to your application form or to this reference, please click on this link: {{ application_url }}\n\nSincerely,\nCampus Crusade for Christ",
                         :subject => "STINT/Internship Reference for {{ applicant_full_name }}")
    EmailTemplate.create(:name => "Reference Complete",
                         :content => "Dear {{ applicant_full_name }}:\n\nA reference form filled out by {{ reference_full_name }} recommending you for a STINT/Internship has been completed and was submitted on {{ reference_submission_date }}.  You are now one step closer to finding out the decision about your internship application!   When a final decision is reached, we will let you know.  We trust that God will use this time of waiting as you continue to seek His will.\n\nSincerely,\nCampus Crusade for Christ",
                         :subject => "STINT/Internship Reference Complete for {{ applicant_full_name }}")
    EmailTemplate.create(:name => "Reference Thank You",
                         :content => "Dear {{ reference_full_name }}:\n\nThank you for completing the reference form for {{ applicant_full_name }}!  You are helping this applicant to make an eternal spiritual investment!  We thank you for giving of your limited time in order to give us insight about this applicant.\n\nSincerely,\nCampus Crusade for Christ",
                         :subject => "Thank You for Completing an Internship Reference for {{ applicant_full_name }}")
  end

  def self.down
  end
end
