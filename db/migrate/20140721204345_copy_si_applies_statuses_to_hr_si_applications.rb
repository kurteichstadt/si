class CopySiAppliesStatusesToHrSiApplications < ActiveRecord::Migration
  def up
    execute "update hr_si_applications apps join si_applies_deprecated applies on apps.apply_id = applies.id set apps.status = applies.status"
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

end
