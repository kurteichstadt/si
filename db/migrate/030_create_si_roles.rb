class CreateSiRoles < ActiveRecord::Migration
  def self.up
    create_table SiRole.table_name do |t|
      t.column :role,     :string, :null => false
      t.column :user_class,  :string, :null => false
    end
    
    SiRole.create(:role => "General Staff", :user_class => "SiGeneralStaff")
    SiRole.create(:role => "National Coordinator", :user_class => "SiNationalCoordinator")
  end

  def self.down
    drop_table SiRole.table_name
  end
end
