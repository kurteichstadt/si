class HrSiProjectsController < ApplicationController
  include AuthenticatedSystem
  skip_before_filter :cas_filter, :only => [:get_valid_projects, :projects_feed, :show]
  skip_before_filter :authentication_filter, :only => [:get_valid_projects, :projects_feed, :show]
  prepend_before_filter :ssm_login_required, :only => [:get_valid_projects]
  prepend_before_filter :login_from_cookie
  before_filter :check_valid_user, :except => [:get_valid_projects, :projects_feed, :show]
  layout 'admin', :except => :get_valid_projects
  respond_to :html, :js
  
  def index
    params[:partnershipRegion] ||= -1
    @regions = [["",-1]] + Region.all.collect { |r| [ r.name, r.region ] }
    @countries = [""] + Country.order("country").collect { |c| [ c.country + ' (' + c.code + ')', c.code ] }
    @aoas = [""] + Aoa.all.collect { |a| [a.name, a.id ] }
    @years_for_select = ((2003)..(Fe::Application::YEAR - 1)).to_a.map(&:to_s)
    @years_for_select << ["Current",Fe::Application::YEAR]
    @years_for_select.reverse!
  end
  
  def new 
    @hr_si_project = HrSiProject.new
    @regions = Region.all.collect { |r| [ r.name, r.region ] }
    @countries = Country.order("country").collect { |c| [ c.country + ' (' + c.code + ')', c.code ] }
    @aoas = Aoa.all.collect { |a| a.name }
  end
  
  def edit
    @hr_si_project = HrSiProject.find(params[:id])
    @regions = Region.all.collect { |r| [ r.name, r.region ] }
    @countries = Country.order("country").collect { |c| [ c.country + ' (' + c.code + ')', c.code ] }
    @aoas = Aoa.all.collect { |a| a.name }
  end
  
  def show
    edit
    @active = "opportunities"
    respond_to do |format|
      format.html { render :layout => 'public' }
      format.xml { render :xml => @hr_si_project.to_xml(:only => [:SIProjectID, :studentStartDate,
                                                   :studentEndDate, :details,
                                                   :displayLocation,
                                                   :studentCost, :partnershipRegion]) }
    end
  end
  
  def create
    @hr_si_project = HrSiProject.new(project_params)
    @hr_si_project.siYear = Fe::Application::YEAR
    @regions = Region.all.collect { |r| [ r.name, r.region ] }
    @countries = Country.order("country").collect { |c| [ c.country + ' (' + c.code + ')', c.code ] }
    @aoas = Aoa.all.collect { |a| a.name }

    respond_to do |format|
      if @hr_si_project.save
        flash[:notice] = 'Project was successfully created.'
        format.html { redirect_to hr_si_projects_path }
        format.xml  { head :created, :location => hr_si_project_path(@hr_si_project) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @hr_si_project.errors.to_xml }
      end
    end
  end
  
  def update
    @hr_si_project = HrSiProject.find(params[:id])

    respond_to do |format|
      if @hr_si_project.update_attributes(project_params)
        flash[:notice] = 'Project was successfully updated.'
        format.html { redirect_to hr_si_projects_path }
        format.xml  { head :ok }
      else
        @regions = Region.all.collect { |r| [ r.name, r.region ] }
        @countries = Country.order("country").collect { |c| [ c.country + ' (' + c.code + ')', c.code ] }
        @aoas = Aoa.all.collect { |a| a.name }
        format.html { render :action => "edit" }
        format.xml  { render :xml => @hr_si_project.errors.to_xml }
      end
    end
  end
  
  def projects_feed
    params[:format] = "xml"
    search
    render :xml => @projects.to_xml(:only => [:SIProjectID, :studentStartDate,
                                                   :studentEndDate, :details,
                                                   :displayLocation,
                                                   :studentCost, :partnershipRegion])
  end

  def search
    @regions = [["",-1]] + Region.all.collect { |r| [ r.name, r.region ] }
    @countries = [""] + Country.order("country").collect { |c| [ c.country + ' (' + c.code + ')', c.code ] }
    @aoas = [""] + Aoa.all.collect { |a| a.name }
    @years_for_select = ((2003)..(Fe::Application::YEAR - 1)).to_a.map(&:to_s)
    @years_for_select << ["Current",Fe::Application::YEAR]
    @years_for_select.reverse!

    #XML Feed needs
    params[:partnershipRegion] = params[:region] unless params[:region].to_s.empty?
    params[:siYear] = Fe::Application::YEAR.to_s if params[:format] == "xml"

    conditions = "1=1 "
    conditions += "and name like '%#{escape_string(params[:name])}%' " unless params[:name].to_s.empty?
    conditions += "and city like '%#{escape_string(params[:city])}%' " unless params[:city].to_s.empty?
    if params[:country].to_s=="INTL"
          conditions += "and country <>'USA' "
    elsif !params[:country].to_s.empty?
          conditions += "and country like '%#{params[:country]}%' "
    end
    conditions += "and partnershipRegion like '%#{params[:partnershipRegion]}%' " unless params[:partnershipRegion].to_i == -1
    conditions += "and aoa like '%#{params[:AOA]}%' " unless params[:AOA].to_s.empty?
    conditions += "and studentStartDate >= '#{Date.parse(params[:studentStartDate])}' " unless params[:studentStartDate].to_s.empty?
    conditions += "and studentEndDate <= '#{Date.parse(params[:studentEndDate])}' " unless params[:studentEndDate].to_s.empty?
    conditions += "and siYear like '%#{escape_string(params[:siYear])}' " unless params[:siYear].to_s.empty?
    
    if conditions.blank? 
      @projects = HrSiProject.all
    else
      @projects = HrSiProject.where(conditions)
    end
  end
  
  def get_valid_projects
    person = current_person
    @application = person.application
    @project_preference = Fe::ProjectPreference.find(params[:dom_id].split('_').last)
    @dom_id = params[:dom_id]
    @projects = Array.new
    show_all = params[:show_all] == "true" ? true : false
    if !@application.nil?
      locations = "'#{@application.locationA}','#{@application.locationB}','#{@application.locationC}'"
      campus = Campus.where(:name => person.campus).where("state = ?", person.universityState).first
      region = campus.region unless campus.nil?
      project_type = 'n'
      @projects = HrSiProject.find_all_available(locations, region, show_all, person, project_type)
    end
    #respond_with(@application, @project_preference, @dom_id, @projects)
  end

  def project_params
    params.require(:hr_si_project).permit!
  end
end
