class UpdateSitrackTrackingToUseApplyId < ActiveRecord::Migration
  def change
    execute "update sitrack_tracking t join hr_si_applications a on t.application_id = a.apply_id set t.application_id = a.id"
  end
end
