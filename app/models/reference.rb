require 'uuidtools'

class Reference < ActiveRecord::Base
  set_table_name "#{TABLE_NAME_PREFIX}character_references"   # `references` is a reserved word in MySQL
  
  include ActionController::UrlWriter # named routes
  default_url_options[:host] = 'www.powertochange.jobs'       # set this to what you want!!
      
  acts_as_state_machine :initial => :created, :column => :status

  state :started, :enter => Proc.new {|ref|
                              ref.started_at = Time.now
                            }
  state :created
  state :completed, :enter => Proc.new {|ref|
                                ref.submitted_at = Time.now
                                # TODO: Do we need to send a notification here?
                              }

  event :start do
    transitions :to => :started, :from => :created
  end

  event :submit do
    transitions :to => :completed, :from => :started
  end

  belongs_to :apply
  belongs_to :sleeve_sheet
  
  after_save :check_app_complete
  
  attr_accessor :title  # fixed title from sleeve_sheet
  
  # :name, :months_known, etc. are quite necessary... no validates here because I want auto-save to still work with incomplete forms
  
  validates_length_of [:name, :email, :phone], :maximum => 255, :allow_nil => true
  validates_numericality_of :months_known, :only_integer => true, :allow_nil => true
  
  def check_app_complete
    if self.completed?
      self.apply.complete
    end
  end
  
  def frozen?
    !%w(started).include?(self.status)
  end
  
  def started?
    %w(started).include?(self.status)
  end
  
  def completed?
    %(completed).include?(self.status)
  end

  def before_validation_on_create
    create_new_token
  end
  
  def create_new_token
     self.token = UUID.timestamp_create.to_s
  end
  
  def email_sent?() !self.email_sent_at.nil? end
  
  # send email invite
  def send_invite    
    return if self.email.blank?   # bypass blanks for now
    
    application = self.apply
    
    Notifier.deliver_notification(self.email,
                                  "help@campuscrusadeforchrist.com", 
                                  "Reference Invite", 
                                  {'reference_full_name' => self.name, 
                                   'applicant_full_name' => application.applicant.informal_full_name,
                                   'applicant_email' => application.applicant.email, 
                                   'applicant_home_phone' => application.applicant.current_address.homePhone, 
                                   'reference_url' => edit_reference_url(application, self.token)})
  end
    
end
