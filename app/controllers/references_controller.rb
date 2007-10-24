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
    # look up reference information provided by Applicant
    @reference = @application.references.find_by_token(params[:id])
    
    if @reference.nil?
      raise "No reference form found for token '#{params[:id]}'."
    end
    
    @reference.start! unless @reference.started?
    
    # find or create answer sheet for reference to fill in
    @answer_sheet = @application.find_or_create_reference_answer_sheet(@reference.sleeve_sheet)
    
    # edit the first page
    @presenter = AnswerPagesPresenter.new(self, @answer_sheet)
    @elements = @presenter.questions_for_page(:first).elements
    
    render :template => 'answer_sheets/edit'
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
    @reference = @application.references.find_by_token(params[:id])

    if @reference.nil?
      raise "No reference form found for token '#{params[:id]}'."
    end
    
    @answer_sheet = @application.find_or_create_reference_answer_sheet(@reference.sleeve_sheet)
    @question_sheet = @answer_sheet.question_sheet
    @elements = @question_sheet.elements.find(:all, :include => 'page', 
                                                    :conditions => ["#{Element.table_name}.kind not in (?) ", %w(Section Paragraph)],
                                                    :order => "#{Page.table_name}.number,#{Element.table_name}.position")
    @elements = QuestionSet.new(@elements, @answer_sheet).elements.group_by(&:page_id)
    
    render :template => 'answer_sheets/show'
  end
  
  def send_invite
    # Save references on page first
    @references = @application.reference_sheets.index_by(&:sleeve_sheet_id)
    params[:references].each do |sleeve_sheet_id, data|
      sleeve_sheet_id = sleeve_sheet_id.to_i
      # @references[sleeve_sheet_id] ||= @application.references.build(:sleeve_sheet_id => sleeve_sheet_id) # new reference if needed
      @references[sleeve_sheet_id].attributes = data  # store posted data
      @references[sleeve_sheet_id].save! 
    end
    
    @reference = Reference.find(params[:id])
    send_reference_invite(@reference)
  end

  private
  def setup
    @application = Apply.find(params[:application_id])
  end
end
