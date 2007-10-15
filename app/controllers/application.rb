# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter AuthenticationFilter, :except => ['no_access','logout']
  helper_method :is_true, :si_user, :user

  include CommonEngine

  @@application_name = "si"
  cattr_accessor :application_name
  
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_boat_session_id'

  def current_person
    raise "no user" unless user
    # Get their user, or create a new one if theirs doesn't exist
    p = user.person || user.create_person_and_address
    p
  end
  
  def user
    if session[:casfilterreceipt]
      @user ||= User.find_by_globallyUniqueID(session[:casfilterreceipt].attributes[:ssoGuid])
      return @user
    end
    if session[:user_id]
      @user ||= User.find_by_id(session[:user_id])
      return @user
    end
    return false unless @user
  end

  def si_user
    return nil unless user
    @si_user ||= SiUser.find_by_ssm_id(user.id)
    unless @si_user
      @si_user = SiUser.new(:ssm_id => user.id)
      # check to see if they are staff
      @si_user = user.person.isStaff? ? SiGeneralStaff.new(:ssm_id => user.id) : SiUser.new(:ssm_id => user.id)
    end
    unless session[:login_stamped]
      @si_user.update_attribute(:last_login, Time.now)
      session[:login_stamped] = true
    end
    @si_user
  end

  def get_valid_projects(show_all)
    conditions = "siYear = #{HrSiApplication::YEAR}"
    @projects = HrSiProject.find(:all, :conditions => conditions, :order => "name ASC")
  end

  protected # not user-accessible
  
  # custom pages in sidebar of application
  def custom_pages(apply)
    [
      PageLink.new('References', edit_reference_page_path(apply), 'reference_page'),
      PageLink.new('Payment', edit_payment_page_path(apply), 'payment_page'),
      PageLink.new('Submit Application', edit_submit_page_path(apply), 'submit_page')
    ]
  end
  
  def next_custom_page(apply, after_page_dom)
    custom_pages = custom_pages(apply)
    this_page = custom_pages.find { |p| p.dom_id == after_page_dom }
    custom_pages[custom_pages.index(this_page).succ]
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

  def send_reference_invite(reference)
    unless reference.email.nil?
      # Send invite to reference
      Notifier.deliver_notification(reference.email,
                                    "help@campuscrusadeforchrist.com", 
                                    "Reference Invite", 
                                    {'reference_full_name' => reference.name, 
                                     'applicant_full_name' => @application.applicant.informal_full_name,
                                     'applicant_email' => @application.applicant.email, 
                                     'applicant_home_phone' => @application.applicant.current_address.homePhone, 
                                     'reference_url' => edit_reference_url(@application, reference.token)})

      # Send notification to applicant
      Notifier.deliver_notification(@application.applicant.email, # RECIPIENTS
                                    "help@campuscrusadeforchrist.com", # FROM
                                    "Reference Notification to Applicant", # LIQUID TEMPLATE NAME
                                    {'applicant_full_name' => @application.applicant.informal_full_name,
                                     'reference_full_name' => reference.name,
                                     'reference_email' => reference.email,
                                     'application_url' => edit_application_url(@application)})

    reference.email_sent_at = Time.now
    reference.save
    end
  end
end
