Factory.define :address do |a|
  a.association :person
  a.email       'test@example.com'
  a.homePhone   '555-555-5555'
  a.addressType 'current'
end