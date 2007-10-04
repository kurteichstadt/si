class CreateEmailTemplates < ActiveRecord::Migration
  def self.up
    create_table EmailTemplate.table_name do |t|
      t.column :name,     :string,  :limit => 60, :null => false
      t.column :content,  :text  
      t.column :enabled,  :boolean
      t.column :subject,  :string
    end
  end

  def self.down
    drop_table EmailTemplate.table_name
  end
end
