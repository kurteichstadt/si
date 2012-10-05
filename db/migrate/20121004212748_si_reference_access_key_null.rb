class SiReferenceAccessKeyNull < ActiveRecord::Migration
  def up
    change_column :si_references, :access_key, :string, :null => true
  end

  def down
  end
end
