class CreateProjectPreferences < ActiveRecord::Migration
  def self.up
    create_table :project_preferences do |t|
    end
  end

  def self.down
    drop_table :project_preferences
  end
end
