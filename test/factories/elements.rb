Factory.define :element do |e|
  e.association   :quesiton_sheet
  e.association   :page
  e.kind          'TextField'
  e.label         'First Name'
  e.style         'short'
end