class AddFeeToApplication < ActiveRecord::Migration
  def self.up
    add_column Sleeve.table_name, :fee_amount, :decimal
  end

  def self.down
    remove_column Sleeve.table_name, :fee_amount
  end
end
