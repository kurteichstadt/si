class QuestionnaireToVersion7 < ActiveRecord::Migration
  def self.up
    Rails.plugins["questionnaire"].migrate(7)
  end

  def self.down
    Rails.plugins["questionnaire"].migrate(6)
  end
end
