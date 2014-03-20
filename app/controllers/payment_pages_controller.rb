# gather payment information from Applicant
class PaymentPagesController < ApplicationController
  skip_before_filter :cas_filter
  skip_before_filter :authentication_filter
  
  before_filter :setup

  layout nil
  
  def staff_search
    first = params[:payment][:staff_first]
    last = params[:payment][:staff_last]
    if first.blank? || last.blank?
      render and return
    end
    @results = Staff.where(["(firstName like ? OR preferredName like ?) AND lastName like ? and removedFromPeopleSoft <> 'Y'", first+'%', first+'%', last+'%'])
                    .order('lastName, firstName')
  end

 private
  def setup
    @application = Apply.find(params[:application_id])
  end

end
