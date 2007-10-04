class RemoveSleeveSheetIdFromPayment < ActiveRecord::Migration
  def self.up
    remove_column Payment.table_name, :sleeve_sheet_id
  end

  def self.down
    add_column Payment.table_name, :sleeve_sheet_id, :integer, :null => false, :references => SleeveSheet.table_name
  end
end
