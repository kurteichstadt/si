class AddSubmitPage < ActiveRecord::Migration
  def self.up
    p = Page.create!(:question_sheet_id => 1, :label => "Submit", :number => 20)

    e1 = Element.new(:question_sheet_id => 1, :kind => "Section", :style => "section", :label => "Submit Application", :position => 1)
    e1.kind = "Section" # for some reason isn't setting in above line, must be rails keyword?
    e1.save!
    e2 = Element.new(:question_sheet_id => 1, :kind => "Paragraph", :style => "paragraph", :content => "<p>Campus Crusade for Christ requires that you certify your application by submitting an electronic signature. To certify your application, read the text below and provide an electronic signature (type your name) and click Submit Application.</p>
<ol>
  <li>
    I have read, understood, and agree with the enclosed <a href='http://www.cru.org/about-us/statement-of-faith/index.htm' target='_blank'>Statement of Faith</a>.</li>
  <li>
    If accepted for a STINT or Internship, I am aware that I am responsible to raise whatever financial support is necessary to fund my involvement with Campus Crusade for Christ.</li>
  <li>
    To the best of my knowledge, all of the information in this application is true and complete. I also authorize you to make such inquiries as may be necessary in arriving at an acceptance decision, which includes contacting the people completing my references, my local Campus Crusade for Christ staff person, or others. I hereby release those persons from all liability to inquiries in connection with my application.</li>
</ol>
", :position => 2)
    e2.kind = "Paragraph" # for some reason isn't setting in above line, must be rails keyword?
    e2.save!
    e3 = Element.new(:question_sheet_id => 1, :kind => "TextField", :style => "short", :label => "Enter Electronic Signature (type your name)", :required => true, :position => 3)
    e3.kind = "TextField" # for some reason isn't setting in above line, must be rails keyword?
    e3.save!

    PageElement.create!(:page_id => p.id, :element_id => e1.id, :position => 1)
    PageElement.create!(:page_id => p.id, :element_id => e2.id, :position => 2)
    PageElement.create!(:page_id => p.id, :element_id => e3.id, :position => 3)
  end

  def self.down
  end
end
