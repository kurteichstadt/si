Factory.define :hr_si_application do |h|
  h.association   :person
  h.association   :apply
  h.siYear        HrSiApplication::YEAR
end