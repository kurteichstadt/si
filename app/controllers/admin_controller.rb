class AdminController < ApplicationController
  before_filter :check_valid_user, :except => [:no_access, :logout]
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
    #This used to be 2003, but since old apps will error out, set it to 2008
    #until historical data is restored...
    @years_for_select = ((2008)..(HrSiApplication::YEAR - 1)).to_a.map(&:to_s)
    @years_for_select << ["Current",HrSiApplication::YEAR]
    @years_for_select.reverse!
  end
  
  def logout
    reset_session
    redirect_to "https://signin.ccci.org/cas/logout"
  end
  
  def select_region
    unless params[:region]
      redirect_to :action => :index
      return
    end
    @region = Region.find_by_region(params[:region])
    @year = params[:year] || HrSiApplication::YEAR
    apply_base = Apply.by_region(@region.region, @year)
    # Started apps are those that meet the following conditions:
    #   - First Name or Last Name filled in (check :person)
    @started_apps = apply_base.find(:all,
                                    :conditions => ["(#{Person.table_name}.firstName != '' or #{Person.table_name}.lastName != '') AND #{Apply.table_name}.status IN(?)", Apply.unsubmitted_statuses])
    # In Process apps
    @in_process_apps = apply_base.find(:all, :conditions => ["#{Apply.table_name}.status IN(?)", Apply.not_ready_statuses] )

    # Ready apps are those that meet the following conditions:
    #   - Submitted (or Completed)
    #     AND Paid
    #     AND All References Submitted
    @ready_apps = apply_base.find(:all, :conditions => ["#{Apply.table_name}.status IN(?)", Apply.ready_statuses])
    
    # Post Ready apps
    # Everything from Evaluation through Termination, but not the ppl who dropped out
    @post_ready_apps = apply_base.find(:all, :conditions => ["#{Apply.table_name}.status IN(?)", Apply.post_ready_statuses])
    
    # Not Going apps
    # Withdrawn or declined
    @not_going = apply_base.find(:all, :conditions => ["#{Apply.table_name}.status IN(?)", Apply.not_going_statuses])
  end


end
