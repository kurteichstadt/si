Factory.define :person do |p|
  p.firstName   'GI'
  p.lastName    'Joe'
  p.association :user
end

Factory.define :josh, :parent => :person do |p|
  p.firstName   'Josh'
  p.lastName    'Starcher'
  p.association :user, :factory => :josh_user
end