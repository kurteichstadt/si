Factory.define :sleeve_sheet do |s|
  s.association :sleeve
  s.association :question_sheet
  s.title 'STINT / Internship Application'
  s.assign_to 'applicant'
end
  
Factory.define :ref_sheet, :parent => :sleeve_sheet do |s|
  s.association :sleeve
  s.association :question_sheet, :factory => :ref_question_sheet
  s.title 'Reference'
  s.assign_to 'reference'
end