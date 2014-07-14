module Fe
  class AnswerSheetsController < ApplicationController
    include Fe::AnswerSheetsControllerConcern

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
      # Add some security to this method
      def get_answer_sheet
        @answer_sheet = answer_sheet_type.find(params[:id])
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
  end
end
