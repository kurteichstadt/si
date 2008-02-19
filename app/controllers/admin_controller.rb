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
    

    Apply.with_scope(:find => {:include => [:applicant, :references, :hr_si_application, :payments],
                               :conditions => ["#{HrSiApplication.table_name}.siYear = ? and #{Person.table_name}.region = ?", @year, @region.region],
                               :order => "#{Person.table_name}.lastName, #{Person.table_name}.firstName"}) do

      # Started apps are those that meet the following conditions:
      #   - First Name or Last Name filled in (check :person)
      @started_apps = Apply.find(:all,
                                 :conditions => ["(#{Person.table_name}.firstName != '' or #{Person.table_name}.lastName != '') AND #{Apply.table_name}.status IN(?)", Apply.unsubmitted_statuses])
      # In Process apps
      @in_process_apps = Apply.find(:all, :conditions => ["#{Apply.table_name}.status IN(?)", Apply.not_ready_statuses] )

      # Ready apps are those that meet the following conditions:
      #   - Submitted (or Completed)
      #     AND Paid
      #     AND All References Submitted
      @ready_apps = Apply.find(:all, :conditions => ["#{Apply.table_name}.status IN(?)", Apply.ready_statuses], 
                                     :order => "#{Person.table_name}.lastName" )
    end 
  end


end
