# to save elements in alternate tables
class AddObjectAttributeToElements < ActiveRecord::Migration
  def self.up
    add_column Element.table_name,   :object_name,      :string
    add_column Element.table_name,   :attribute_name,   :string
  end

  def self.down
    remove_column Element.table_name, :object_name
    remove_column Element.table_name, :attribute_name
  end
end
