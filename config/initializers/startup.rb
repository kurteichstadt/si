CAS::Filter.login_url = "https://signin.mygcx.org/cas/login"
CAS::Filter.validate_url = "https://signin.mygcx.org/cas/serviceValidate"

ExceptionNotifier.exception_recipients = %w(josh.starcher@uscm.org justin.sabelko@uscm.org)
ExceptionNotifier.sender_address = %(si_error@uscm.org)
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