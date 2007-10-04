class SetDefaultValueForElementIsConfidential < ActiveRecord::Migration
  def self.up
    change_column Element.table_name, :is_confidential, :boolean, :default => false 
  end

  def self.down
    change_column Element.table_name, :is_confidential, :boolean
  end
end
