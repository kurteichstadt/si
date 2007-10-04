class CreateReferences < ActiveRecord::Migration
  def self.up
    create_table Reference.table_name do |t|
      t.column :apply_id, :integer, :null => false
      t.column :sleeve_sheet_id, :integer, :null => false
      t.column :name, :string, :limit => 255, :null => false
      t.column :email, :string, :limit => 255, :null => true
      t.column :phone, :string, :limit => 255, :null => true
      t.column :months_known, :integer, :null => true
      t.column :status, :string, :limit => 36, :null => false
      t.column :token, :string, :limit => 36, :null => false
      
      # foreign keys
      t.foreign_key :apply_id, Apply.table_name, :id
      t.foreign_key :sleeve_sheet_id, SleeveSheet.table_name, :id
    end
    
    add_index Reference.table_name, :token
  end

  def self.down
    drop_table Reference.table_name
  end
end
