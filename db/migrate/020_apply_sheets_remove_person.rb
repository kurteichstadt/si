class ApplySheetsRemovePerson < ActiveRecord::Migration
  def self.up
    #remove_foreign_key ApplySheet.table_name, 'apply_sheets_ibfk_2'    # remove_foreign_key isn't working, and ApplySheets.foreign_keys returns nothing []
    remove_column ApplySheet.table_name, :person_id
  end

  def self.down
    add_column ApplySheet.table_name, :person_id, :integer, :default => 0, :null => false
    add_foreign_key ApplySheet.table_name, :person_id, Person.table_name, :personID
  end
end
