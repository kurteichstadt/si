class Run
  def self.daily_tasks
    check_pay_by_check_apps
  end
  
  def self.check_pay_by_check_apps
    payments = Payment.find_all_by_payment_type("Mail")
    payments.each do |payment|
      payment.check_app_complete
    end
  end
  
  #In addition to running this method we need to add two rows to sitrack_enum_values
  #There are also a few month/year questions on the application that need additional years added as choices
  def self.change_si_year
    last_years = HrSiProject.find_all_by_siYear("2013")
    last_years.each do |project|
      attrs = project.attributes.clone

      attrs.delete("SIProjectID")
      new_project = HrSiProject.new(attrs)
      new_project.siYear = "2014"
      new_project.studentStartDate = new_project.studentStartDate + 1.year if new_project.studentStartDate
      new_project.studentEndDate = new_project.studentEndDate + 1.year if new_project.studentEndDate
      new_project.staffStartDate = new_project.staffStartDate + 1.year if new_project.staffStartDate
      new_project.staffEndDate = new_project.staffEndDate + 1.year if new_project.staffEndDate
      new_project.leadershipStartDate = new_project.leadershipStartDate + 1.year if new_project.leadershipStartDate
      new_project.leadershipEndDate = new_project.leadershipEndDate + 1.year if new_project.leadershipEndDate
      new_project.departDateFromGateCity = new_project.departDateFromGateCity + 1.year if new_project.departDateFromGateCity
      new_project.arrivalDateAtLocation = new_project.arrivalDateAtLocation + 1.year if new_project.arrivalDateAtLocation
      new_project.departDateFromLocation = new_project.departDateFromLocation + 1.year if new_project.departDateFromLocation
      new_project.arrivalDateAtGatewayCity = new_project.arrivalDateAtGatewayCity + 1.year if new_project.arrivalDateAtGatewayCity
      new_project.save(:validate => false) #Don't perform validations cause we don't care when we're just copying
    end
    nil
  end
end