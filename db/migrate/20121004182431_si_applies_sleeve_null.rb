class SiAppliesSleeveNull < ActiveRecord::Migration
  def up
    change_column :si_applies, :sleeve_id, :integer, :null => true
  end

  def down
  end
end
