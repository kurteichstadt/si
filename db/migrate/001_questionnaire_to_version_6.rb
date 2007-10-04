class QuestionnaireToVersion6 < ActiveRecord::Migration
  def self.up
    Rails.plugins["questionnaire"].migrate(6)
  end

  def self.down
    Rails.plugins["questionnaire"].migrate(0)
  end
end
