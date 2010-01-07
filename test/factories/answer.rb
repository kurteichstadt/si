Factory.define :answer do |a|
  a.association :answer_sheet
  a.association :question
  a.value       'long foo'
  a.short_value 'foo'
end