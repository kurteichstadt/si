Factory.define :si_user, :class => SiNationalCoordinator do |s|
  s.role 'National Coordinator'
  s.association :user, :factory => :josh_user
end