class RenameSiAppliesToSiAppliesDeprecated < ActiveRecord::Migration
  def change
    rename_table :si_applies, :si_applies_deprecated
  end
end
