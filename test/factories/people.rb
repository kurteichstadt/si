Factory.define :person do |p|
  p.firstName   'GI'
  p.lastName    'Joe'
  p.association :user
end