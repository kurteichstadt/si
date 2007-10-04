class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table Payment.table_name do |t|
      t.column :apply_id, :integer, :null => false, :references => Apply.table_name
      t.column :sleeve_sheet_id, :integer, :null => false, :references => SleeveSheet.table_name
      t.column :payment_type, :string
      t.column :amount, :string
      t.column :payment_account_no, :string
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table Payment.table_name
  end
end
