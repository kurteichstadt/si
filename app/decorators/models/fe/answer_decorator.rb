Fe::Answer.class_eval do
  def before_save
    q = Element.find(question_id)
    
    if q.present? && q.object_name.present? && q.attribute_name.present?
      @application = application
      unless eval("@application." + q.object_name + ".nil?")
        value = Regexp.escape(self.value)
        value = value.gsub(/"/, '\"')
        eval("@application." + q.object_name + ".update_attribute(:" + q.attribute_name + ", \"" + value + "\")")  
        # Prevents actual answer from saving
        return false
      end
      
    end
  end
  
  def application
    unless @apply
      #answer_sheet = Fe::AnswerSheet.find(answer_sheet_id)
      #apply_sheet = ApplySheet.find_by_answer_sheet_id(answer_sheet.id)
      @apply = Apply.find(answer_sheet_id)
    end
    @apply
  end
end
