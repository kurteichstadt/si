class AddCreatedAtToHrSiApplications < ActiveRecord::Migration
  def change
    add_column :hr_si_applications, :created_at, :datetime
    execute "update hr_si_applications SET created_at = started_at"
  end
end
