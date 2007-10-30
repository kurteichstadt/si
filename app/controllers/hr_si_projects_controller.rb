class HrSiProjectsController < ApplicationController
  skip_before_filter CAS::Filter, :only => [:get_valid_projects]
  skip_before_filter AuthenticationFilter, :only => [:get_valid_projects]
  layout 'admin', :except => :get_valid_projects
  
  def index
    params[:partnershipRegion] ||= -1
    @regions = [["",-1]] + Region.find(:all).collect { |r| [ r.name, r.region ] }
    @countries = [""] + Country.find(:all).collect { |c| [ c.country + ' (' + c.code + ')', c.code ] }
    @aoas = [""] + Aoa.find(:all).collect { |a| [a.name, a.id ] }
    @years_for_select = ((2003)..(HrSiApplication::YEAR - 1)).to_a.map(&:to_s)
    @years_for_select << ["Current",HrSiApplication::YEAR]
    @years_for_select.reverse!
  end
  
  def new 
    @hr_si_project = HrSiProject.new
    @regions = Region.find(:all).collect { |r| [ r.name, r.region ] }
    @countries = Country.find(:all).collect { |c| [ c.country + ' (' + c.code + ')', c.code ] }
    @aoas = Aoa.find(:all).collect { |a| a.name }
  end
  
  def edit
    @hr_si_project = HrSiProject.find(params[:id])
    @regions = Region.find(:all).collect { |r| [ r.name, r.region ] }
    @countries = Country.find(:all).collect { |c| [ c.country + ' (' + c.code + ')', c.code ] }
    @aoas = Aoa.find(:all).collect { |a| a.name }
  end
  
  def show
    edit
    render :xml => @hr_si_project.to_xml(:only => [:SIProjectID, :studentStartDate,
                                                   :studentEndDate, :details,
                                                   :displayLocation,
                                                   :studentCost, :partnershipRegion])
  end
  
  def create
    @hr_si_project = HrSiProject.new(params[:hr_si_project])
    @hr_si_project.siYear = HrSiApplication::YEAR
    @regions = Region.find(:all).collect { |r| [ r.name, r.region ] }
    @countries = Country.find(:all).collect { |c| [ c.country + ' (' + c.code + ')', c.code ] }
    @aoas = Aoa.find(:all).collect { |a| a.name }

    respond_to do |format|
      if @hr_si_project.save
        flash[:notice] = 'Project was successfully created.'
        format.html { redirect_to hr_si_projects_url }
        format.xml  { head :created, :location => hr_si_project_url(@hr_si_project) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @hr_si_project.errors.to_xml }
      end
    end
  end
  
  def update
    @hr_si_project = HrSiProject.find(params[:id])

    respond_to do |format|
      if @hr_si_project.update_attributes(params[:hr_si_project])
        flash[:notice] = 'Project was successfully updated.'
        format.html { redirect_to hr_si_projects_url }
        format.xml  { head :ok }
      else
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
    @regions = [["",-1]] + Region.find(:all).collect { |r| [ r.name, r.region ] }
    @countries = [""] + Country.find(:all).collect { |c| [ c.country + ' (' + c.code + ')', c.code ] }
    @aoas = [""] + Aoa.find(:all).collect { |a| a.name }
    @years_for_select = ((2003)..(HrSiApplication::YEAR - 1)).to_a.map(&:to_s)
    @years_for_select << ["Current",HrSiApplication::YEAR]
    @years_for_select.reverse!

    #XML Feed needs
    params[:partnershipRegion] = params[:region] unless params[:region].to_s.empty?
    params[:siYear] = HrSiApplication::YEAR.to_s if params[:format] == "xml"

    conditions = "1=1 "
    conditions += "and name like '%#{escape_string(params[:name])}%' " unless params[:name].to_s.empty?
    conditions += "and city like '%#{escape_string(params[:city])}%' " unless params[:city].to_s.empty?
    conditions += "and country like '%#{params[:country]}%' " unless params[:country].to_s.empty?
    conditions += "and partnershipRegion like '%#{params[:partnershipRegion]}%' " unless params[:partnershipRegion].to_i == -1
    conditions += "and aoa like '%#{params[:AOA]}%' " unless params[:AOA].to_s.empty?
    conditions += "and studentStartDate like '%#{Date.strptime(params[:studentStartDate], "%d/%m/%Y")}%' " unless params[:studentStartDate].to_s.empty?
    conditions += "and studentEndDate like '%#{Date.strptime(params[:studentEndDate], "%d/%m/%Y")}%' " unless params[:studentEndDate].to_s.empty?
    conditions += "and siYear like '%#{escape_string(params[:siYear])}' " unless params[:siYear].to_s.empty?
    
    if conditions.blank? 
      @projects = HrSiProject.find(:all)
    else
      @projects = HrSiProject.find(:all, :conditions => conditions)
    end
  end
  
  def get_valid_projects
    person = current_person
    application = Apply.find(person.current_si_application.apply_id)
    @projects = Array.new
    show_all = params[:show_all] == "true" ? true : false
    if !application.nil?
      locations = "'#{person.current_si_application.locationA}','#{person.current_si_application.locationB}','#{person.current_si_application.locationC}'"
      campus = Campus.find_by_name(person.campus, :conditions => ["state = ?", person.universityState])
      region = campus.region unless campus.nil?
      project_type = 'n'
      @projects = HrSiProject.find_all_available(locations, region, show_all, person, project_type)
    end
    render(:layout => false)
  end
end
