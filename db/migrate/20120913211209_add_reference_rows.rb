class AddReferenceRows < ActiveRecord::Migration
  def self.up
    p = Page.create!(:question_sheet_id => 1, :label => "References", :number => 18)
    e1 = Element.new(:question_sheet_id => 1, :page_id => p.id, :kind => "ReferenceQuestion", :style => "staff", :label => "Staff Reference", :required => true, :position => 1, :related_question_sheet_id => 2)
    e1.kind = "ReferenceQuestion" # for some reason isn't setting in above line, must be rails keyword?
    e1.save!
    e2 = Element.new(:question_sheet_id => 1, :page_id => p.id, :kind => "ReferenceQuestion", :style => "discipler", :label => "Discipler Reference", :required => true, :position => 2, :related_question_sheet_id => 2)
    e2.kind = "ReferenceQuestion"
    e2.save!
    e3 = Element.new(:question_sheet_id => 1, :page_id => p.id, :kind => "ReferenceQuestion", :style => "roommate", :label => "Roommate Reference", :required => true, :position => 3, :related_question_sheet_id => 2)
    e3.kind = "ReferenceQuestion"
    e3.save!
    e4 = Element.new(:question_sheet_id => 1, :page_id => p.id, :kind => "ReferenceQuestion", :style => "friend", :label => "Friend Reference", :required => true, :position => 4, :related_question_sheet_id => 2)
    e4.kind = "ReferenceQuestion"
    e4.save!
    
    PageElement.create!(:page_id => p.id, :element_id => e1.id, :position => 1)
    PageElement.create!(:page_id => p.id, :element_id => e2.id, :position => 2)
    PageElement.create!(:page_id => p.id, :element_id => e3.id, :position => 3)
    PageElement.create!(:page_id => p.id, :element_id => e4.id, :position => 4)
    
    execute("UPDATE si_references SET question_id = #{e1.id} where question_id = 2")
    execute("UPDATE si_references SET question_id = #{e2.id} where question_id = 3")
    execute("UPDATE si_references SET question_id = #{e3.id} where question_id = 4")
    execute("UPDATE si_references SET question_id = #{e4.id} where question_id = 5")
  end

  def self.down
  end
end
