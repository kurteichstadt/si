Factory.define :hr_si_project do |p|
  p.name                'Test Project'
  p.partnershipRegion   'SW'
  p.city                'Here'
  p.country             'USA'
  p.displayLocation     'Italy:Rome'
  p.projectType         's'
  p.studentStartDate    Time.now
  p.studentEndDate      1.month.from_now
end