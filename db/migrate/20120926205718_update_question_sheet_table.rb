class UpdateQuestionSheetTable < ActiveRecord::Migration
  def self.up
    add_column :si_question_sheets, :archived, :boolean, :default => false
  end

  def self.down
  end
end
