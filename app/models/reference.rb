require 'digest/md5'
class Reference < ActiveRecord::Base
  set_table_name "#{TABLE_NAME_PREFIX}character_references"   # `references` is a reserved word in MySQL
  
  include ActionController::UrlWriter # named routes
      
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
    transitions :to => :completed, :from => :created
    transitions :to => :completed, :from => :started
  end

  belongs_to :apply
  belongs_to :sleeve_sheet
  
  after_save :check_app_complete
  
  attr_accessor :title  # fixed title from sleeve_sheet
  
  # :name, :months_known, etc. are quite necessary... no validates here because I want auto-save to still work with incomplete forms
  
  validates_length_of :name, :email, :phone, :maximum => 255, :allow_nil => true
  validates_numericality_of :months_known, :only_integer => true, :allow_nil => true
  validates_format_of :email, :with => /.{1,}[@][\w\-]{1,}([.]([\w\-]{1,})){1,3}$/i, :if => Proc.new { |ref| !ref.email.blank? }
  
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
     self.token = object_id.to_s + ':' + Digest::MD5.hexdigest((object_id + Time.now.to_i).to_s)
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
                                   'reference_url' => edit_application_reference_url(application, self.token, :host => ActionMailer::Base.default_url_options[:host])})
  end
  
protected
  def valid_email?
    unless email.blank?
      TMail::Address.parse(email)
    end
  rescue
    errors.add_to_base("Must be a valid email")
  end

end
