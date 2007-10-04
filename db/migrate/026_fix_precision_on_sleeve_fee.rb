class FixPrecisionOnSleeveFee < ActiveRecord::Migration
  def self.up
    change_column Sleeve.table_name, :fee_amount, :decimal, :precision => 9, :scale => 2, :default => 0
  end

  def self.down
    change_column Sleeve.table_name :fee_amount, :decimal
  end
end
