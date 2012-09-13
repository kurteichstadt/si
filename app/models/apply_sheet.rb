# links sheets
class ApplySheet < ActiveRecord::Base
  set_table_name "#{TABLE_NAME_PREFIX}#{self.table_name}"
  
  belongs_to :apply
  belongs_to :sleeve_sheet    # back to question sheet and retitle
  belongs_to :answer_sheet_question_sheet, :foreign_key => :answer_sheet_id
  
end
