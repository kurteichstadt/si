Factory.define :question_sheet do |q|
  q.label 'STINT / Internship Application'
end

Factory.define :ref_question_sheet, :parent => :question_sheet do |q|
  q.label 'Reference'
end