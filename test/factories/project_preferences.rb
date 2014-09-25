FactoryGirl.define do
  factory :project_preference, :parent => :element, :class => 'Fe::ProjectPreference' do
    kind            'Fe::ProjectPreference'
    label           'Project Preference'
    style           'project_preference'
    object_name     'application'
    attribute_name  'locationA'
  end
end
