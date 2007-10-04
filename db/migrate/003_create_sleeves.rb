class CreateSleeves < ActiveRecord::Migration
  def self.up
    create_table Sleeve.table_name do |t|
      t.column :title, :string, :limit => 60, :null => false
      t.column :slug, :string, :limit => 36, :null => true
      # language?
    end
    
    add_index Sleeve.table_name, :slug, :unique => true
  end

  def self.down
    drop_table Sleeve.table_name
  end
end
