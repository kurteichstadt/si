class AddACoupleQuestions < ActiveRecord::Migration
  def up
    e1 = Element.new(:question_sheet_id => 1, :kind => "TextField", :style => "essay", :label => "4. Do you have any other plans for the summer months other than focusing on MPD?",
                     :required => 1, :position => 8, :object_name => "hr_si_application", :attribute_name => "mpd_summer_plans")
    e1.kind = "TextField" # for some reason isn't setting in above line, must be rails keyword?
    e1.save!
    PageElement.create!(:page_id => 16, :element_id => e1.id, :position => 8)

    e2 = Element.new(:question_sheet_id => 1, :kind => "ChoiceField", :style => "radio", :label => "What are you applying for?",
                     :content => "STINT\nUS Internship\nPart Time Field Staff", :required => 1, :position => 1, 
                     :object_name => "hr_si_application", :attribute_name => "app_type")
    e2.kind = "ChoiceField" # for some reason isn't setting in above line, must be rails keyword?
    e2.save!
    PageElement.create!(:page_id => 6, :element_id => e2.id, :position => 1)
  end

  def down
  end
end
