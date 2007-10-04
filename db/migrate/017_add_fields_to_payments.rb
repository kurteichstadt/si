class AddFieldsToPayments < ActiveRecord::Migration
  def self.up
    add_column Payment.table_name,  :auth_code,     :string
    add_column Payment.table_name,  :status,        :string
    add_column Payment.table_name,  :updated_at,    :datetime
  end

  def self.down
    remove_column Payment.table_name, :auth_code
    remove_column Payment.table_name, :status
    remove_column Payment.table_name, :update_at
  end
end
