class AddSubmittedAtToReference < ActiveRecord::Migration
  def self.up
    add_column  Reference.table_name, :submitted_at,    :datetime
  end

  def self.down
    remove_column Reference.table_name, :submitted_at
  end
end
