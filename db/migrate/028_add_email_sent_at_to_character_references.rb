class AddEmailSentAtToCharacterReferences < ActiveRecord::Migration
  def self.up
    add_column Reference.table_name, :email_sent_at, :datetime
  end

  def self.down
    remove_column Reference.table_name, :email_sent_at
  end
end
