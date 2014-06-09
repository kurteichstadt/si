class Fe::ReferenceSheetsController < Fe::AnswerSheetsController
  def edit
    content_for :title, "STINT/Internship/PTFS Application"
    super
  end
end
