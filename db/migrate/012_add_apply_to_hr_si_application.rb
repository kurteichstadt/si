class AddApplyToHrSiApplication < ActiveRecord::Migration
  def self.up
    add_column :hr_si_applications, :apply_id, :integer
  end

  def self.down
    remove_column :hr_si_applications, :apply_id
  end
end
