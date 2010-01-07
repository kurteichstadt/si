Factory.define :apply_sheet do |a|
  a.association :apply
  a.association :sleeve_sheet
  a.association :answer_sheet
end