class RemoveQuestionSheetIdFromElement < ActiveRecord::Migration
  def change
    remove_column :si_elements, :question_sheet_id
    remove_column :si_elements, :position
  end
end
