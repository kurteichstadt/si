Factory.define :reference do |r|
  r.association :apply
  r.association :sleeve_sheet
  r.token         { UUIDTools::UUID.timestamp_create.to_s }
  r.name          'Refer Me'
  r.email         'refer@example.com'
  r.phone         '444-444-4444'
  r.months_known  '3'
end