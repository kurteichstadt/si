Factory.define :element do |e|
  e.association   :question_sheet
  e.association   :page
  e.kind          'TextField'
  e.label         'First Name'
  e.style         'short'
  e.required      false
end

Factory.define :school_picker, :parent => :element, :class => 'SchoolPicker' do |s|
  s.kind            'SchoolPicker'
  s.label           'Pick School'
  s.style           'school_picker'
  s.object_name     'applicant'
  s.attribute_name  'campus'
end

Factory.define :project_preference, :parent => :element, :class => 'ProjectPreference' do |s|
  s.kind            'ProjectPreference'
  s.label           'Project Preference'
  s.style           'project_preference'
  s.object_name     'hr_si_application'
  s.attribute_name  'locationA'
end