# a Sleeve is a container for QuestionSheets
#  :title       a sheet can be retitled (i.e. 'Reference' => 'Friend Reference')
#               and the same sheet can occur multiple times in a single sleeve
#  :assign_to   forms assigned to a reference are sent to someone else to complete
class SleeveSheet < ActiveRecord::Base
  set_table_name "#{TABLE_NAME_PREFIX}#{self.table_name}"
  
  belongs_to :sleeves
  belongs_to :question_sheet
  has_many :apply_sheets  # people applying for this sheet

  validates_presence_of :title, :assign_to
  validates_inclusion_of :assign_to, :in => ['applicant', 'reference', 'internal']
 
  validates_length_of :title, :maximum => 60, :allow_nil => true
 
  # drop down options for assign_to
  def self.assignees
    [
      ['Applicant', 'applicant'],
      ['Reference', 'reference'],
    ]
  end
  
  def assign_to_text
    SleeveSheet.assignees.find {|name,value| value == self.assign_to }[0]
  end
   
end
