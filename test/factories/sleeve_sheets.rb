Factory.define :sleeve_sheet do |s|
  s.association :sleeve
  s.association :question_sheet
  s.title 'STINT / Internship Application'
  s.assign_to 'applicant'
end
  
Factory.define :ref_sheet, :parent => :sleeve_sheet do |s|
  s.association :sleeve
  s.association :question_sheet, :factory => :ref_question_sheet
  s.title 'Staff Reference'
  s.assign_to 'reference'
end

Factory.define :d_ref_sheet, :parent => :sleeve_sheet do |s|
  s.association :sleeve
  s.association :question_sheet, :factory => :ref_question_sheet
  s.title 'Discipler Reference'
  s.assign_to 'reference'
end

Factory.define :r_ref_sheet, :parent => :sleeve_sheet do |s|
  s.association :sleeve
  s.association :question_sheet, :factory => :ref_question_sheet
  s.title 'Roommate Reference'
  s.assign_to 'reference'
end

Factory.define :f_ref_sheet, :parent => :sleeve_sheet do |s|
  s.association :sleeve
  s.association :question_sheet, :factory => :ref_question_sheet
  s.title 'Friend Reference'
  s.assign_to 'reference'
end