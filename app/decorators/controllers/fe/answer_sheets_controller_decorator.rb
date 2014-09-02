Fe::AnswerSheetsController.class_eval do
  #include Fe::AnswerSheetsControllerConcern

  skip_before_filter CAS::Filter, :except => [:show, :collated_refs, :no_conf, :no_ref]
  skip_before_filter AuthenticationFilter
  prepend_before_filter :ssm_login_required, :except => [:no_access, :show, :no_ref, :no_conf, :collated_refs]
  prepend_before_filter :login_from_cookie
  append_before_filter :check_valid_user, :only => [:show, :collated_refs, :no_conf, :no_ref]

  layout 'application'

  prepend_before_filter :login

  def submit
    session[:attempted_submit] = true
    return false unless validate_sheet
    case @answer_sheet.class.to_s
    when 'Fe::Application'
      @answer_sheet.submit!

      # send references
      @answer_sheet.references.each do |reference|
        reference.send_invite unless reference.email_sent?
      end
      render 'fe/applications/submitted'
    when 'Fe::ReferenceSheet'
      @answer_sheet.submit! unless @answer_sheet.completed?
      render 'fe/reference_sheets/submitted'
    else
      super
    end
    return false
  end

protected

  def get_year
    Fe::Application::YEAR  
  end
  
  def create_application
    @application = Fe::Application.create :applicant_id => @person.id, :si_year => get_year
  end

  # Add some security to this method
  def get_answer_sheet
    @application = @answer_sheet = answer_sheet_type.find(params[:id])
    case @answer_sheet.class.to_s
    when 'Fe::Application'
      unless @answer_sheet.applicant == current_person || (si_user && si_user.can_su_application?)
        redirect_to root_path
        return false
      end
    when 'Fe::ReferenceSheet'

    else
      redirect_to root_path
      return false
    end

  end

  def login
    ssm_login_required unless answer_sheet_type.to_s == 'Fe::ReferenceSheet'
  end

  def validate_sheet
    return false unless super
    if @application.payments.length < 1
      @answer_sheet.errors.add(:base, "You must supply at least one payment.")
      @presenter = Fe::AnswerPagesPresenter.new(self, @answer_sheet, params[:a])
      render 'incomplete'
      return false
    end
    return true
  end
end
