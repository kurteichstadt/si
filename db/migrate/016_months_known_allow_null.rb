# months_known should be required, but allow null for auto-save with partial data
class MonthsKnownAllowNull < ActiveRecord::Migration
  def self.up
    change_column Reference.table_name, :months_known, :integer, :null => true   # also modified in 008 migration
  end

  def self.down
    change_column Reference.table_name, :months_known, :integer, :null => false, :default => 0
  end
end
