Factory.define :page do |p|
  p.association   :question_sheet
  p.label         'Welcome!'
  p.number        1
end