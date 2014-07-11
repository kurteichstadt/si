# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require 'authenticated_system'
require 'authentication_filter'
class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include Fe::ApplicationControllerConcern

  before_filter :authentication_filter, :except => ['no_access','logout']
  helper_method :is_true, :si_user, :user

  @@application_name = "si"
  cattr_accessor :application_name
  
  def current_person
    raise "no user" unless user
    # Get their person, or create a new one if theirs doesn't exist
    p = user.fe_person 
    p ||= user.create_person_and_address(firstName: session[:cas_extra_attributes]['firstName'], lastName: session[:cas_extra_attributes]['lastName']) if session[:cas_extra_attributes]
    p
  end
  helper_method :current_person
  
  def user
    if session[:user_id]
      @user ||= User.find_by_id(session[:user_id])
      if params[:user_id] && params[:su] && (@user.developer? || (session[:old_user_id] && old_user = User.find(session[:old_user_id]).developer?))
        session[:old_user_id] = @user.id if @user.developer?
        session[:user_id] = params[:user_id] 
        @user = User.find(session[:user_id])
      end
      return @user
    end
    if session[:cas_user]
      @user ||= User.find_by(username: session[:cas_user])
      return @user
    end
    if session[:casfilterreceipt]
      @user ||= User.find_by_globallyUniqueID(session[:casfilterreceipt].attributes[:ssoGuid])
      return @user
    end
    return false unless @user
  end
  helper_method :user

  def si_user
    return nil unless user
    @si_user ||= SiUser.where(ssm_id: user.id).first_or_create
    #@si_user ||= SiUser.where(ssm_id: user.id).first
    if @si_user && !session[:login_stamped]
      @si_user.update_attribute(:last_login, Time.now)
      session[:login_stamped] = true
    end
    @si_user
  end

  def check_valid_user
    unless si_user
      redirect_to :controller => :admin, :action => :no_access
      return false
    end
  end

  # def get_valid_projects(show_all)
  #   conditions = "siYear = #{Fe::Application::YEAR}"
  #   @projects = HrSiProject.find(:all, :conditions => conditions, :order => "name ASC")
  # end

  # custom pages in sidebar of application
  def custom_pages(apply)
    [
#      PageLink.new('References', edit_application_reference_page_path(apply), dom_page(apply.answer_sheets.first, Page.new), Page.new),
#      PageLink.new('Payment', edit_application_payment_page_path(apply), dom_page(apply.answer_sheets.first, Page.new), Page.new),
#      PageLink.new('Submit Application', edit_application_submit_page_path(apply), dom_page(apply.answer_sheets.first, Page.new), Page.new)
    ]
  end
  
  def next_custom_page(apply, after_page_dom)
    custom_pages = custom_pages(apply)
    this_page = custom_pages.find { |p| p.dom_id == after_page_dom }
    custom_pages[custom_pages.index(this_page).succ] if this_page
  end

  # since i'm doing a lot of raw SQL, i need to do my own escaping.
  # i would credit Josh with this, but he stole it too
   def escape_string(str)
     str.gsub(/([\0\n\r\032\'\"\\])/) do
       case $1
       when "\0" then "\\0"
       when "\n" then "\\n"
       when "\r" then "\\r"
       when "\032" then "\\Z"
       else "\\"+$1
       end
     end
   end

  def is_true(val)
    [1,'1',true,'true'].include?(val)
  end
  
  def is_false(val)
    [0,'0',false,'false'].include?(val)
  end
  
  #def update_references
  #  @references = @application.reference_sheets.index_by(&:id)
  #  params[:references].each do |id, data|
  #    id = id.to_i
  #    # @references[sleeve_sheet_id] ||= @application.references.build(:sleeve_sheet_id => sleeve_sheet_id) # new reference if needed
  #    # If email address changes, we need a new link and a new answer sheet
  #    # data["email"] = data["email"].gsub(/â€[[:cntrl:]]/, '').strip # try to get rid of weird characters and spaces
  #    if(data["email"] != @references[id].email)
  #      @references[id].create_new_token
  #      @references[id].email_sent_at = nil
  #      #@application.find_or_create_reference_answer_sheet(@references[id].question_sheet, true)
  #    end
  #    @references[id].attributes = data  # store posted data
  #    @references[id].save
  #  end
  #end

  def send_reference_invite(reference)
    @sent = false
    unless reference.email.nil? || reference.email.empty?
      # Send invite to reference
      if (reference.send_invite)
        @sent = true
      end

      # Send notification to applicant
      Fe::Notifier.notification(@application.applicant.email, # RECIPIENTS
                                    "help@campuscrusadeforchrist.com", # FROM
                                    "Reference Notification to Applicant", # LIQUID TEMPLATE NAME
                                    {'applicant_full_name' => @application.applicant.informal_full_name,
                                     'reference_full_name' => reference.name,
                                     'reference_email' => reference.email,
                                     'application_url' => edit_application_url(@application)}).deliver

    reference.email_sent_at = Time.now
    reference.save
    end
  end
  
  # FORCE to implement content_for in controller
  def view_context
    super.tap do |view|
      (@_content_for || {}).each do |name,content|
        view.content_for name, content
      end
    end
  end
  def content_for(name, content) # no blocks allowed yet
    @_content_for ||= {}
    if @_content_for[name].respond_to?(:<<)
      @_content_for[name] << content
    else
      @_content_for[name] = content
    end
  end
  def content_for?(name)
    @_content_for[name].present?
  end

  private
  
  # page is identified by answer sheet, so can have multiple sheets loaded at once
  def dom_page(answer_sheet, page)
    dom = "#{dom_id(answer_sheet)}-#{dom_id(page)}"
    dom += "-no_cache" if page.no_cache
    dom
  end

  def cas_filter
    CASClient::Frameworks::Rails::Filter.filter(self) unless session[:cas_user]
  end

  def authentication_filter
    AuthenticationFilter.filter(self)
  end

end
