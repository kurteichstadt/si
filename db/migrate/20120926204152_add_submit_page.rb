class AddSubmitPage < ActiveRecord::Migration
  def self.up
    p = Page.create!(:question_sheet_id => 1, :label => "Submit", :number => 20)

    e1 = Element.new(:question_sheet_id => 1, :kind => "Fe::Section", :style => "section", :label => "Submit Application", :position => 1)
    e1.kind = "Fe::Section" # for some reason isn't setting in above line, must be rails keyword?
    e1.save!
    e2 = Element.new(:question_sheet_id => 1, :kind => "Fe::Paragraph", :style => "paragraph", :content => "<p>If you are sure you are finished with the application, click 'Submit'.
        After you submit your application, you will not be able to edit your answers in your 
        application, but you will be able to change your your personal information, your 
        school information, and your reference information as necessary.</p>
<p>
    To the best of my knowledge, all of the information in this application is true and complete. I also authorize you to make such inquiries as may be necessary in arriving at an acceptance decision, which includes contacting the people completing my references, my local Campus Crusade for Christ staff person, or others. I hereby release those persons from all liability to inquiries in connection with my application.
</p>
", :position => 2)
    e2.kind = "Fe::Paragraph" # for some reason isn't setting in above line, must be rails keyword?
    e2.save!

    PageElement.create!(:page_id => p.id, :element_id => e1.id, :position => 1)
    PageElement.create!(:page_id => p.id, :element_id => e2.id, :position => 2)
  end

  def self.down
  end
end
