class AdminController < ApplicationController
  layout 'admin'
  
  def ssl_test
    out = "ssl? " + request.ssl?.inspect + "<br/>"
    env = request.instance_variable_get(:@env)
    env.each_pair do |key, value|
      out += key.to_s + ': ' + value.to_s + "<br/>"
    end
    render :text => out
  end

  def index
    @years_for_select = ((2003)..(HrSiApplication::YEAR - 1)).to_a.map(&:to_s)
    @years_for_select << ["Current",HrSiApplication::YEAR]
    @years_for_select.reverse!
  end
  
  def logout
    reset_session
    redirect_to "https://signin.mygcx.org/cas/logout"
  end
  
  def select_region
    unless params[:region]
      redirect_to :action => :index
      return
    end
    @region = Region.find_by_region(params[:region])
    @year = params[:year] || HrSiApplication::YEAR
    
    Apply.with_scope(:find => {:include => [:applicant, :references, :hr_si_application],
                               :conditions => ["#{HrSiApplication.table_name}.siYear = ? and #{Person.table_name}.region = ?", @year, @region.region],
                               :order => "#{Person.table_name}.lastName, #{Person.table_name}.firstName"}) do

      # Start with a list of all applications for this region
      @apps_in_region = Apply.find(:all)

      # Started apps are those that meet the following conditions:
      #   - First Name or Last Name filled in (check :person)
      @started_apps = Apply.find(:all,
                                 :conditions => "#{Person.table_name}.firstName != '' or #{Person.table_name}.lastName != ''")
    end                                 
                               
    # In Process apps
    @in_process_apps = Array.new()
    @apps_in_region.each do |app|
      @in_process_apps << app if app.submitted? or app.has_paid? or app.completed_references.length == app.sleeve.reference_sheets.length
    end
      
    # Ready apps are those that meet the following conditions:
    #   - Submitted (or Completed)
    #     AND Paid
    #     AND All References Submitted
    @ready_apps = Array.new()
    @apps_in_region.each do |app|
      @ready_apps << app if app.submitted? and app.has_paid? and app.completed_references.length == app.sleeve.reference_sheets.length
    end
    
    @started_apps.reject! {|app| @in_process_apps.include?(app) or @ready_apps.include?(app)}
    @in_process_apps.reject! { |app| @ready_apps.include?(app)}
  end

end
