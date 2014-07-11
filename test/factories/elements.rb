FactoryGirl.define do
  factory :element, class: 'Fe::Element' do
    kind          'Fe::TextField'
    label         'First Name'
    style         'short'
    required      false
  end

  factory :school_picker, :parent => :element, :class => 'SchoolPicker' do
    kind            'SchoolPicker'
    label           'Pick School'
    style           'school_picker'
    object_name     'applicant'
    attribute_name  'campus'
  end

  factory :project_preference, :parent => :element, :class => 'ProjectPreference' do
    kind            'ProjectPreference'
    label           'Project Preference'
    style           'project_preference'
    object_name     'hr_si_application'
    attribute_name  'locationA'
  end
end
