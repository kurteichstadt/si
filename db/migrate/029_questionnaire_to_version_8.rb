class QuestionnaireToVersion8 < ActiveRecord::Migration
  def self.up
    Rails.plugins["questionnaire"].migrate(8)
  end

  def self.down
    Rails.plugins["questionnaire"].migrate(7)
  end
end
