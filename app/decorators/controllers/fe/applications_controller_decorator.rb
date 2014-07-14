Fe::ApplicationsController.class_eval do
  skip_before_filter CAS::Filter, :except => [:show, :collated_refs, :no_conf, :no_ref]
  skip_before_filter AuthenticationFilter
  prepend_before_filter :ssm_login_required, :except => [:no_access, :show, :no_ref, :no_conf, :collated_refs]
  prepend_before_filter :login_from_cookie
  append_before_filter :check_valid_user, :only => [:show, :collated_refs, :no_conf, :no_ref]

  layout 'application'

protected

  def get_year
    Fe::Application::YEAR  
  end
  
  def create_application
    @application = Fe::Application.create :applicant_id => @person.id, :si_year => get_year
  end
end
