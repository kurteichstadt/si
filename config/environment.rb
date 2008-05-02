# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '1.2.3' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here
  
  # Skip frameworks you're not going to use (only works if using vendor/rails)
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Only load the plugins named here, by default all plugins in vendor/plugins are loaded
  # config.plugins = %W( exception_notification ssl_requirement )

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/app/presenters )
  
  # Force all environments to use the same logger level 
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper, 
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
  
  # See Rails::Configuration for more options
  
end

# Add new inflection rules using the following format 
# (all these examples are active by default):
# Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register "application/x-mobile", :mobile

# Include your application configuration below

CAS::Filter.login_url = "https://cas.ccci.org/cas/login"
CAS::Filter.validate_url = "https://cas.ccci.org/cas/serviceValidate"

ExceptionNotifier.exception_recipients = %w(josh.starcher@uscm.org justin.sabelko@uscm.org)
ExceptionNotifier.sender_address = %("Application Error" <si_error@uscm.org>)
ExceptionNotifier.email_prefix = "[SI] "
FILTER_KEYS = %w(card_number expiration_year expiration_month card_type password)
ExceptionNotifier.filter_keys = FILTER_KEYS

# retrieve table_name_prefix from database.yml
# Had to move this here because USCM uses a shared database.yml file for all apps
TABLE_NAME_PREFIX = "si_"
# TABLE_NAME_PREFIX = ActiveRecord::Base.configurations[RAILS_ENV]['table_name_prefix']
Questionnaire.table_name_prefix = TABLE_NAME_PREFIX   # set for Questionnaire engine as well
Questionnaire.answer_sheet_has_one = :apply_sheet

ActionMailer::Base.smtp_settings = {
  :address => "smtp1.ccci.org",
  :domain => "ccci.org"
}

# override default fieldWithErrors behavior
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  msg = instance.error_message
  error_class = "fieldWithErrors" 
  if html_tag =~ /<(input|textarea|select)[^>]+class=/
    style_attribute = html_tag =~ /class=['"]/
    html_tag.insert(style_attribute + 7, "#{error_class} ")
  elsif html_tag =~ /<(input|textarea|select)/
    first_whitespace = html_tag =~ /\s/
    html_tag[first_whitespace] = " class='#{error_class}' " 
  end
  html_tag
end