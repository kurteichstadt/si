class CreateApplies < ActiveRecord::Migration
  def self.up
    create_table Apply.table_name do |t|
      t.column :sleeve_id, :integer, :null => false
      t.column :applicant_id, :integer, :null => false
      t.column :status, :string, :limit => 36, :null => false
      t.column :created_at, :datetime, :null => false
      t.column :submitted_at, :datetime, :null => true
      
      # foreign keys
      t.foreign_key :sleeve_id, Sleeve.table_name, :id
      t.foreign_key :applicant_id, Person.table_name, :personID
    end
    
    add_index Apply.table_name, :status
    add_index Apply.table_name, :submitted_at
  end

  def self.down
    drop_table Apply.table_name
  end
end
