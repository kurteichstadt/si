FactoryGirl.define do
  factory :element, class: 'Fe::Element' do
    kind                'Fe::TextField'
    label               'First Name'
    style               'short'
    required            false
    sequence(:position) { |n| n }
    is_confidential     false
    hide_label          false
    hide_option_labels  false
    association         :question_sheet
  end

  factory :school_picker, :parent => :element, :class => 'Fe::SchoolPicker' do
    kind            'Fe::SchoolPicker'
    label           'Pick School'
    style           'school_picker'
    object_name     'applicant'
    attribute_name  'campus'
  end

  factory :project_preference, :parent => :element, :class => 'Fe::ProjectPreference' do
    kind            'Fe::ProjectPreference'
    label           'Project Preference'
    style           'project_preference'
    object_name     'application'
    attribute_name  'locationA'
  end
end
