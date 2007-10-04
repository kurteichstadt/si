class CreateSleeveSheets < ActiveRecord::Migration
  def self.up
    create_table SleeveSheet.table_name do |t|
      t.column :sleeve_id, :integer, :null => false
      t.column :question_sheet_id, :integer, :null => false
      t.column :title, :string, :null => false, :limit => 60
      t.column :assign_to, :string, :null => false, :limit => 36
      
      # foreign keys
      t.foreign_key :sleeve_id, Sleeve.table_name, :id
      t.foreign_key :question_sheet_id, QuestionSheet.table_name, :id
    end
  end

  def self.down
    drop_table SleeveSheet.table_name
  end
end
