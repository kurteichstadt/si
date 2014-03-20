# Project Preference
# - drop down of available projects
# - user determines whether to display all projects or just those in his/her region

class ProjectPreference < Fe::Question
  def choices(app=nil)
    if !app.nil?
      locations = "'#{app.hr_si_application.locationA}','#{app.hr_si_application.locationB}','#{app.hr_si_application.locationC}'"
      campus = Campus.where("name = ? && state = ?", app.applicant.campus, app.applicant.universityState).first
      region = campus.nil? ? nil : campus.region
      show_all = false
      person = app.applicant
      project_type = 'n'
      @projects = HrSiProject.find_all_available(locations, region, show_all, person, project_type)
      @projects.collect {|x| [x.name, x.id] }
    else
      []
    end
  end

  def display_response(app=nil)
    r = response(app)
    #raise r.inspect
    p = HrSiProject.find_by(SIProjectID: r) unless r.blank?
    if r.blank?
      return ""
    elsif p.nil?
      return "<span class='answerwarn'><b>Applicant's location preference is closed and is no longer being offered as a project.</b></span>"
    else
      return p.displayLocation
    end
  end
end