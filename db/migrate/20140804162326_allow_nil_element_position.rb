class AllowNilElementPosition < ActiveRecord::Migration
  def change
    change_column :si_elements, :position, :integer, null: true
  end
end
