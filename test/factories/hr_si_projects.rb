Factory.define :hr_si_project do |p|
  p.name                'Test Project'
  p.partnershipRegion   'SW'
  p.city                'Here'
  p.country             'USA'
  p.displayLocation     'Italy:Rome'
  p.projectType         's'
  p.studentStartDate    3.days.from_now
  p.studentEndDate      1.month.from_now
  p.siYear              HrSiApplication::YEAR
end