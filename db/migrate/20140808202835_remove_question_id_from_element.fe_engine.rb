# This migration comes from fe_engine (originally 20131016162128)
class RemoveQuestionIdFromElement < ActiveRecord::Migration
  def up
=begin
    remove_column Fe::Element.table_name, :question_sheet_id
=end
  end
  
  def down
=begin
    add_column Fe::Element.table_name, :question_sheet_id, :integer
=end
  end
end
