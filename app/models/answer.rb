# load in original Answer model
require_dependency Rails.root + "/vendor/plugins/questionnaire_engine/app/models/answer"

class Answer < ActiveRecord::Base
  # def after_find
  #   # for some reason, self.question is nil on subsequent initializations
  #   begin
  #     q = Element.find(question_id)
  # 
  #     @application = get_application
  #     
  #     if !q.nil? and !q.object_name.nil? and !q.attribute_name.nil? and !q.object_name.blank? and !q.attribute_name.blank?
  #       self.value = self.short_value = eval("@application." + q.object_name + "." + q.attribute_name) unless eval("@application." + q.object_name + ".nil?")
  #     end
  #   rescue
  #   end
  # end

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
      answer_sheet = AnswerSheet.find(answer_sheet_id)
      apply_sheet = ApplySheet.find_by_answer_sheet_id(answer_sheet.id)
      @apply = Apply.find(apply_sheet.apply_id)
    end
    @apply
  end
end