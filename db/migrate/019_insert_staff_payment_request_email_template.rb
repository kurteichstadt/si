class InsertStaffPaymentRequestEmailTemplate < ActiveRecord::Migration
  def self.up
    EmailTemplate.create(:name => "Staff Payment Request",
                         :content => "Dear {{ reference_full_name }}:\n\n{{ applicant_full_name }} has just applied for an exciting STINT opportunity with Campus Crusade for Christ and has indicated you have agreed to pay the application fee.  If you could take a minute and indicate the account to use, we can continue with the application process.  The application materials will then be reviewed and a decision will be given as soon as possible.\n\nThe payment form is on our secure web site.  Just click on the link below to go directly to the payment form for {{ applicant_full_name }}.  The applicant's application will not processed until payment is made.  Thank you for your help in sending this laborer into the harvest!\n\nYou may contact the applicant by email at {{ applicant_email }} or by phone at {{ applicant_home_phone }}.\n\nFrom the link below, you can either indicate the account number to use for payment or indicate your unwillingness to pay for this application.  Either way, please follow the link and make a determination.\n\nThank you very much.\n\nSincerely,\nCampus Crusade for Christ\n\n<a href=\"{{ reference_url }}\">Click here to access reference form for {{ applicant_full_name }}</a>.\n\nIf the above link does not work.  Please use the following link.  The link should be all in one line, so if it is split up into more than one line, you may need to copy and paste the link into a web browser.\n\n{{ reference_url }}",
                         :subject => "Application Payment Request for {{ applicant_full_name }}")
  end

  def self.down
  end
end
