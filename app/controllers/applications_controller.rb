class ApplicationsController < ApplicationController
  skip_before_filter CAS::Filter, :except => [:show, :collated_refs, :no_conf, :no_ref]
  skip_before_filter AuthenticationFilter
  prepend_before_filter :ssm_login_required, :except => [:no_access, :show, :no_ref, :no_conf, :collated_refs]
  prepend_before_filter :login_from_cookie
  append_before_filter :check_valid_user, :only => [:show, :collated_refs, :no_conf, :no_ref]
  append_before_filter :setup
  
  layout 'application'
  helper :answer_pages
  
  # dashboard
  def index
    redirect_to :action => :show_default
  end
  
  def show_default
    @application = get_application
    setup_view
    
    render :template => 'answer_sheets/edit'
  end
  
  # create app
  def create
    @sleeve = Sleeve.find(params[:sleeve_id])
    @application = @sleeve.applies.build(:applicant => @person)    
    
    @application.save!
    redirect_to application_path(@application)
  end
  
  # edit an application
  def edit
    @application = Apply.find(params[:id]) unless @application

    if @application.applicant == current_user.person
      setup_view
      
      render :template => 'answer_sheets/edit'
    else 
      no_access
    end
    
  end
  
  def show
    @application = Apply.find(params[:id]) unless @application
    @answer_sheets = @application.answer_sheets
    @show_conf = true

    if @answer_sheets.empty?
      render :action => :too_old
      #raise "No applicant sheets in sleeve '#{@application.sleeve.title}'."
      return
    end
  end
  
  def no_ref
    @application = Apply.find(params[:id]) unless @application
    @answer_sheets = [@application]
    @show_conf = true
    
    if @answer_sheets.empty?
      render :action => :too_old
      #raise "No applicant sheets in sleeve '#{@application.sleeve.title}'."
      return
    end
    
    render :template => 'applications/show'
  end
  
  def no_conf
    @application = Apply.find(params[:id]) unless @application
    @answer_sheets = [@application]
    @show_conf = false
    
    if @answer_sheets.empty?
      render :action => :too_old
      #raise "No applicant sheets in sleeve '#{@application.sleeve.title}'."
      return
    end
    
    render :template => 'applications/show'
  end
  
  def collated_refs
    @application = Apply.find(params[:id]) unless @application
    @answer_sheets = @application.references

    if @answer_sheets.empty?
      render :action => :too_old
      #raise "No applicant sheets in sleeve '#{@application.sleeve.title}'."
      return
    end

    @reference_question_sheet = @answer_sheets.empty? ? nil : @answer_sheets[0].question_sheet 

    setup_reference("staff")
    setup_reference("discipler")
    setup_reference("roommate")
    setup_reference("friend")
    
    @show_conf = true
  end

  def setup_reference(type)
    ref = nil
    eval("ref = @" + type + "_reference = @application." + type + "_reference")
    raise type unless ref
    answer_sheet = ref
    question_sheet = answer_sheet.question_sheet
    elements = []
    question_sheet.pages.order(:number).each do |page|
      elements << page.elements.where("#{Element.table_name}.kind not in (?)", %w(Paragraph)).all
    end
    elements = elements.flatten
    elements.reject! {|e| e.is_confidential} if @show_conf == false
    eval("@" + type + "_elements = QuestionSet.new(elements, answer_sheet).elements")

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
    @person.emergency_address1 = Address.new(:addressType =>'emergency1') unless @person.emergency_address1
    @person.permanent_address = Address.new(:addressType =>'permanent') unless @person.permanent_address
    return @person
  end
  
  def get_application
    unless @application
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
    @answer_sheet = @application
    # edit the first page
    @presenter = AnswerPagesPresenter.new(self, @answer_sheet, custom_pages(@application))
    @elements = @presenter.questions_for_page(:first).elements
    @page = @presenter.pages.first
    @presenter.active_page ||= @page
  end
end

