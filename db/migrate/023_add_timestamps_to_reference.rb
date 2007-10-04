class AddTimestampsToReference < ActiveRecord::Migration
  def self.up
    add_column Reference.table_name, :created_at, :datetime
    add_column Reference.table_name, :started_at, :datetime
  end

  def self.down
    remove_column Reference.table_name, :started_at
    remove_column Reference.table_name, :created_at
  end
end
