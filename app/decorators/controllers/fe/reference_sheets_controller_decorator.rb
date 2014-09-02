Fe::ReferenceSheetsController.class_eval do
  def edit
    content_for :title, "STINT/Internship/PTFS Application"
    super
  end
end
