# override some methods from Questionnaire plugin to enable Application-level handling
module Fe
  class AnswerPagesController < ApplicationController
    include Fe::AnswerPagesControllerConcern
    protected

    def get_answer_sheet
      @application = @answer_sheet = answer_sheet_type.find(params[:answer_sheet_id])
      @presenter = AnswerPagesPresenter.new(self, @answer_sheet, params[:a])
    end

  end
end