# Project Preference
# - drop down of available projects
# - user determines whether to display all projects or just those in his/her region

class ProjectPreference < Question
  def choices(app=nil)
    if !app.nil?
      locations = "'#{app.applicant.current_si_application.locationA}','#{app.applicant.current_si_application.locationB}','#{app.applicant.current_si_application.locationC}'"
      campus = Campus.find_by_name(app.applicant.campus, :conditions => ["state = ?", app.applicant.universityState])
      region = campus.nil? ? nil : campus.region
      show_all = false
      person = app.applicant
      project_type = 'n'
      @projects = HrSiProject.find_all_available(locations, region, show_all, person, project_type)
      @projects = @projects.collect {|x| [x.name, x.SIProjectID] }
    else
      []
    end
  end
  
  def display_response(app=nil)
    r = get_response(app)
    p = HrSiProject.find(r) unless r.nil?
    if p.nil? 
      return ""
    else
      return p.displayLocation
    end
  end
end