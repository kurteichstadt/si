class MakeHrSiApplicationsColumnNamesMoreRailsy < ActiveRecord::Migration
  def change
    rename_column :hr_si_applications, :applicationID, :id
    rename_column :hr_si_applications, :fk_ssmUserID, :user_id
    rename_column :hr_si_applications, :fk_personID, :applicant_id
    rename_column :hr_si_applications, :dateAppLastChanged, :updated_at
    rename_column :hr_si_applications, :dateAppStarted, :started_at
    rename_column :hr_si_applications, :dateSubmitted, :submitted_at
    rename_column :hr_si_applications, :siYear, :si_year

    remove_column :hr_si_applications, :submitDate
    remove_column :hr_si_applications, :appStatus
  end
end
