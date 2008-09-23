class Run
  def self.change_si_year
    last_years = HrSiProject.find_all_by_siYear("2008")
    last_years.each do |project|
      new_project = project.clone
      new_project.siYear = "2009"
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
      new_project.save(false) #Don't perform validations cause we don't care when we're just copying
    end
    nil
  end
end