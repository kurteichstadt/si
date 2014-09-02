# override some methods from Questionnaire plugin to enable Application-level handling
Fe::AnswerPagesController.class_eval do
  def get_answer_sheet
    @application = @answer_sheet = answer_sheet_type.where(:id => params[:answer_sheet_id]).first
    if @answer_sheet.nil?
      @application = @answer_sheet = Fe::ReferenceSheet.find_by_id_and_access_key(params[:answer_sheet_id], params[:a])
    end
    @presenter = Fe::AnswerPagesPresenter.new(self, @answer_sheet, params[:a])
  end
end
