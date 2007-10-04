class ApplicationsController < ApplicationController
  include AuthenticatedSystem
  skip_before_filter CAS::Filter 
  skip_before_filter AuthenticationFilter
  prepend_before_filter :ssm_login_required, :except => [:no_access, :show, :no_ref, :no_conf, :collated_refs]
  prepend_before_filter :login_from_cookie
  before_filter :setup
  
  layout 'application'
  helper :answer_pages
  
  # dashboard
  def index
    @sleeves = Sleeve.find(:all)
    @applications = @person.applies.find(:all)
  end
  
  def show_default
    @application = get_application
    if @application
      setup_view
      
      render :template => 'answer_sheets/edit'
    else
      raise "Could not find a default application for you."
    end
  end
  
  # create app
  def create
    @sleeve = Sleeve.find(params[:sleeve_id])
    @application = @sleeve.applies.build(:applicant => @person)    
    
    if @application.save
      redirect_to application_path(@application)
    else
      render :nothing => true, :status => 500
    end
  end
  
  # edit an application
  def edit
    @application = Apply.find(params[:id]) unless @application

    setup_view
    
    render :template => 'answer_sheets/edit'
  end
  
  def show
    @application = Apply.find(params[:id]) unless @application
    @answer_sheets = @application.answer_sheets
    @show_conf = true

    if @answer_sheets.empty?
      raise "No applicant sheets in sleeve '#{@application.sleeve.title}'."
    end
  end
  
  def no_ref
    @application = Apply.find(params[:id]) unless @application
    @answer_sheets = @application.find_or_create_applicant_answer_sheets
    @show_conf = true
    
    if @answer_sheets.empty?
      raise "No applicant sheets in sleeve '#{@application.sleeve.title}'."
    end
    
    render :template => 'applications/show'
  end
  
  def no_conf
    @application = Apply.find(params[:id]) unless @application
    @answer_sheets = @application.find_or_create_applicant_answer_sheets
    @show_conf = false
    
    if @answer_sheets.empty?
      raise "No applicant sheets in sleeve '#{@application.sleeve.title}'."
    end
    
    render :template => 'applications/show'
  end
  
  def collated_refs
    @application = Apply.find(params[:id]) unless @application
    @answer_sheets = @application.reference_answer_sheets
    @show_conf = true
    
    if @answer_sheets.empty?
      raise "No Reference sheets in sleeve '#{@application.sleeve.title}'."
    end
    
    render :template => 'applications/show'
  end
  
  def no_access
    redirect_to :controller => :account, :action => :login
  end

protected
  def setup
    @person = get_person    # current visitor_id
  end

  def get_year
    HrSiApplication::YEAR  
  end
  
  def get_person
    @person ||= current_person
    @person.current_address = Address.new(:addressType =>'current') unless @person.current_address
    @person.emergency_address = Address.new(:addressType =>'emergency1') unless @person.emergency_address
    @person.permanent_address = Address.new(:addressType =>'permanent') unless @person.permanent_address
    return @person
  end
  
  def get_application
    if @application
      @person ||= @application.person   # .applicant??
    else
      @person ||= get_person
      # if this is the user's first visit, we will need to create an hr_si_application
    	if @person.current_si_application.nil?
    		@app = HrSiApplication.create(:siYear => get_year, :fk_personID => @person.id)
    		@person.current_si_application = @app
    end
      if @person.current_si_application.apply_id.nil?
        @application = @person.current_si_application.find_or_create_apply
        @person.current_si_application.save!
      else
        @application ||= Apply.find(@person.current_si_application.apply_id)
      end
    end
    @application
  end

  def setup_view
    @answer_sheets = @application.find_or_create_applicant_answer_sheets
    
    if @answer_sheets.empty?
      raise "No applicant sheets in sleeve '#{@application.sleeve.title}'."
    end
        
    # edit the first page
    @presenter = AnswerPagesPresenter.new(self, @answer_sheets, custom_pages(@application))

    @elements = @presenter.questions_for_page(:first).elements
  end
end

