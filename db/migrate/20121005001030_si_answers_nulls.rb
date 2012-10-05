class SiAnswersNulls < ActiveRecord::Migration
  def up
    change_column :si_answers, :answer_sheet_question_sheet_id, :integer, :null => true
    change_column :si_answers, :answer_sheet_id, :integer, :null => false
  end

  def down
  end
end
