# for Reference completing answer sheet
class ReferencesController < ApplicationController
  skip_before_filter CAS::Filter 
  skip_before_filter AuthenticationFilter
  
  before_filter :setup
  
  layout 'public'
  helper :answer_pages
  
  # AnswerSheet for reference to fill in
  # /applications/1/references/{token}
  def edit
    ref = ReferenceSheet.find_by_access_key(params[:id])
    redirect_to edit_reference_sheet_path(ref, :a => params[:id])
  end

  # final submission
  def submit
    @reference = @application.references.find(params[:id])
    @reference.submit!
    
    # Send Reference Thank You
    Notifier.deliver_notification(@reference.email,
                                  "help@campuscrusadeforchrist.com", 
                                  "Reference Thank You", 
                                  {'reference_full_name' => @reference.name, 
                                   'applicant_full_name' => @application.applicant.informal_full_name})

    
    # Send Reference Completion Notice
    Notifier.deliver_notification(@application.applicant.email,
                                  "help@campuscrusadeforchrist.com", 
                                  "Reference Complete", 
                                  {'reference_full_name' => @reference.name, 
                                   'applicant_full_name' => @application.applicant.informal_full_name,
                                   'reference_submission_date' => @reference.submitted_at.strftime("%m/%d/%Y")})
    
    render :update do |page|
      page[:submit_message].replace_html "Thank you for submitting your reference."
      page[:submit_message].show
      page[:submit_button].hide
    end
  end

  
  def show
    @reference = @application.references.find_by_access_key(params[:id])

    if @reference.nil?
      render :action => :edit
    else
      @answer_sheet = @reference
      @question_sheet = @answer_sheet.question_sheet
      @elements = []
      if @question_sheet
        @question_sheet.pages.order(:number).each do |page|
          @elements << page.elements.where("#{Element.table_name}.kind not in (?)", %w(Section Paragraph)).all
        end
        @elements = @elements.flatten
        @elements = QuestionSet.new(@elements, @answer_sheet).elements.group_by(&:page_id)
      end
    end
  end
  
  def send_invite
    # Save references on page first
    update_references
    
    @reference = Reference.find(params[:id])
    send_reference_invite(@reference)
  end

  private
  def setup
    @application = Apply.find(params[:application_id])
  end
end
