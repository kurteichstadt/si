class SiApplicationMailer < ActionMailer::Base
  def submitted(app)
    setup(app)
    @subject = 'Your STINT/Intern Application has been Received'
  end
  
  def completed(app)
    setup(app)
    @subject = 'Your STINT/Intern Application is Ready for Evaluation'
  end
  
  def withdrawn(app)
    setup(app)
    @subject = 'STINT/Intern Application has been Withdrawn'
  end
  
  def unsubmitted(app)
    setup(app)
    @subject = 'Your STINT/Intern Application is now Incomplete'
    content_type "text/html"
  end
  
  def status(app)
    setup(app)
    @subject    = "Your STINT/Intern application status"

    @body[:paid_app_fee_msg] = app.has_paid? ? app.paid_at : "No"
    @body[:submitted_app_msg] = app.submitted? ? app.submitted_at : "Not complete"
    staff_ref = app.staff_reference
    @body[:staff_ref_msg] = (staff_ref && staff_ref.completed?) ? staff_ref.submitted_at : "Not complete"
    discipler_ref = app.discipler_reference
    @body[:discipler_ref_msg] = (discipler_ref && discipler_ref.completed?) ? discipler_ref.submitted_at : "Not complete"
    roommate_ref = app.roommate_reference
    @body[:roommate_ref_msg] = (roommate_ref && roommate_ref.completed?) ? roommate_ref.submitted_at : "Not complete"
    friend_ref = app.friend_reference
    @body[:friend_ref_msg] = (friend_ref && friend_ref.completed?) ? friend_ref.submitted_at : "Not complete"
  end
  
  def accepted(app)
    setup(app)
    @subject = "Very Important STINT/Intern Information"
  end
  
  protected
    def setup(app)
      @app = app
      @person = app.applicant
      @recipients = app.email_address
      @from = 'stintandinternships@uscm.org'
      @body = {'person' => @person, 'app' => app}
    end
end
