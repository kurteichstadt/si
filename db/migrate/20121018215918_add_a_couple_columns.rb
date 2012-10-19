class AddACoupleColumns < ActiveRecord::Migration
  def up
    add_column :hr_si_applications, :mpd_summer_plans, :text
    add_column :hr_si_applications, :app_type, :string
    
    # Fill in app_type column from SI Tracker for past apps
    SitrackTracking.find_each do |tracking| 
      if !tracking.internType.blank? && ["Internship", "Part Time Field Staff", "STINT"].include?(tracking.internType)
        hrapp = tracking.hr_si_application
        if hrapp
          hrapp.app_type = tracking.internType
          hrapp.save(:validate => false)
        end
      end
    end
    
    execute("update hr_si_applications set app_type = 'US Internship' where app_type = 'Internship'")
  end

  def down
    remove_column :hr_si_applications, :mpd_summer_plans
    remove_column :hr_si_applications, :app_type
  end
end
