class CreateSiUsers < ActiveRecord::Migration
  def self.up
    create_table SiUser.table_name, :force => true do |t|
      t.column  :ssm_id,        :integer
      t.column  :last_login,    :datetime
      t.column  :created_at,    :datetime
      t.column  :created_by_id, :integer
      t.column  :type,          :string
      t.column  :role,          :string
      
      t.foreign_key :ssm_id, :simplesecuritymanager_user, :userID
    end
  end

  def self.down
    drop_table SiUser.table_name
  end
end
