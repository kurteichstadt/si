FactoryGirl.define do
  factory :school_picker, :parent => :element, :class => 'Fe::SchoolPicker' do
    kind            'Fe::SchoolPicker'
    label           'Pick School'
    style           'school_picker'
    object_name     'applicant'
    attribute_name  'campus'
  end
end
