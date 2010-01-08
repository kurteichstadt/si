Factory.define :element do |e|
  e.association   :question_sheet
  e.association   :page
  e.kind          'TextField'
  e.label         'First Name'
  e.style         'short'
end