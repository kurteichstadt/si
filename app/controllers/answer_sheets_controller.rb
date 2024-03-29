require_dependency Rails.root.join('vendor','plugins','questionnaire_engine','app','controllers','answer_sheets_controller').to_s
class AnswerSheetsController < ApplicationController
  prepend_before_filter :login
  
  def submit
    session[:attempted_submit] = true
    return false unless validate_sheet
    case @answer_sheet.class.to_s
    when 'Apply'
      @answer_sheet.submit!
      # send references 
      @answer_sheet.references.each do |reference| 
        reference.send_invite unless reference.email_sent?
      end
      render 'applications/submitted'
    when 'ReferenceSheet'
      @answer_sheet.submit! unless @answer_sheet.completed?
      render 'reference_sheets/submitted'
    else
      super
    end
    return false
  end
  
  protected
    # Add some security to this method
    def get_answer_sheet
      @answer_sheet = answer_sheet_type.find(params[:id])
      case @answer_sheet.class.to_s
      when 'Apply'
        unless @answer_sheet.applicant == current_person || (si_user && si_user.can_su_application?)
          redirect_to root_path
          return false
        end
      when 'ReferenceSheet'
        
      else
        redirect_to root_path
        return false
      end
          
    end
    
    def login
      ssm_login_required unless answer_sheet_type.to_s == 'ReferenceSheet'
    end
end