class CreateApplySheets < ActiveRecord::Migration
  def self.up
    create_table ApplySheet.table_name do |t|
      t.column :apply_id, :integer, :null => false
      t.column :person_id, :integer, :null => false    # individual who is filling it in... an applicant | reference | staff
      t.column :sleeve_sheet_id, :integer, :null => false
      t.column :answer_sheet_id, :integer, :null => false
      
      # foreign keys
      t.foreign_key :apply_id, Apply.table_name, :id
      t.foreign_key :person_id, Person.table_name, :personID
      t.foreign_key :sleeve_sheet_id, SleeveSheet.table_name, :id
      t.foreign_key :answer_sheet_id, AnswerSheet.table_name, :id
    end
  end

  def self.down
    drop_table ApplySheet.table_name
  end
end
