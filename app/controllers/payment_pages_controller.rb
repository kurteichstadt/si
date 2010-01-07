# gather payment information from Applicant
class PaymentPagesController < ApplicationController
  skip_before_filter CAS::Filter
  skip_before_filter AuthenticationFilter
  
  before_filter :setup
  helper :answer_pages
  
  layout nil
  
  # Allow applicant to edit payment
  # /applications/1/payment_page/edit
  # js: provide a partial to replace the answer_sheets page area
  # html: return a full page for editing reference independantly (after submission)
  def edit
    @payment = Payment.new
    @payment.apply = @application
    @next_page = next_custom_page(@application, 'payment_page')
  end
  
  def update
    head :ok
  end
  
  def staff_search
    @payment = Payment.new(params[:payment])
    if @payment.staff_first.strip.empty? || @payment.staff_last.strip.empty?
      render; return
    end
    @results = Staff.find(:all, :order => 'lastName, firstName', :conditions => ["firstName like ? AND lastName like ? and removedFromPeopleSoft <> 'Y'", @payment.staff_first+'%', @payment.staff_last+'%'])
  end

 private
  def setup
    @application = Apply.find(params[:application_id])
  end  
end
