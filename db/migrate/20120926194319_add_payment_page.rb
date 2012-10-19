class AddPaymentPage < ActiveRecord::Migration
  def self.up
    change_column :si_elements, :page_id, :integer, :null => true
    
    p = Page.create!(:question_sheet_id => 1, :label => "Payment", :number => 19)
    e = Element.new(:question_sheet_id => 1, :kind => "PaymentQuestion", :style => "payment_question", :label => "Application Fee", :required => true, :position => 1)
    e.kind = "PaymentQuestion" # for some reason isn't setting in above line, must be rails keyword?
    e.save!
    PageElement.create!(:page_id => p.id, :element_id => e.id, :position => 1)
  end

  def self.down
  end
end
