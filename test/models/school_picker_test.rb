require 'test_helper'

class SchoolPickerTest < ActiveSupport::TestCase

  test "state without app" do
    state = SchoolPicker.new.state
    assert_equal('', state)
  end
  
  test "state method where application has a state" do
    @person = create(:person, :universityState => 'CA')
    setup_application
    state = SchoolPicker.new.state(@apply)
    assert_equal('CA', state)
  end
  
  test "state method where application doesn't have a state" do
    @person = create(:person, :universityState => '', :campus => 'UIUC')
    create(:campus, isSecure: false)
    setup_application
    state = FactoryGirl.build(:school_picker).state(@apply)
    assert_equal('IL', state)
  end
  
  test "choices with campus populated" do
    @person = create(:person, :universityState => 'IL')
    campus = create(:campus)
    setup_application
    assert SchoolPicker.new.colleges(@apply).include?(campus.name)
  end
  
  test "choices with no state" do
    @person = create(:person)
    setup_application
    assert_equal([], FactoryGirl.build(:school_picker).colleges(@apply))
  end
  
  test "validation class" do
    assert_equal('validate-selection required ', SchoolPicker.new(:required => true).validation_class)
    assert_equal('', SchoolPicker.new(:required => false).validation_class)
  end
end
