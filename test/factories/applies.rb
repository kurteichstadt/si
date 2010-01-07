Factory.define :apply do |a|
  a.association   :sleeve
  a.association   :applicant, :factory => :person
  a.status        'started'
end