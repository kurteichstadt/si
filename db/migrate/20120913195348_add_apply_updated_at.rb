class AddApplyUpdatedAt < ActiveRecord::Migration
  def self.up
    add_column :si_applies, :updated_at, :datetime
    
    execute("UPDATE si_applies SET updated_at = created_at")
  end

  def self.down
    remove_column :si_applies, :updated_at
  end
end
