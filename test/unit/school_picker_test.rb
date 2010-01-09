require 'test_helper'

class SchoolPickerTest < ActiveSupport::TestCase

  test "state without app" do
    state = SchoolPicker.new.state
    assert_equal('', state)
  end
  
  test "state method where application has a state" do
    @person = Factory(:person, :universityState => 'CA')
    setup_application
    state = SchoolPicker.new.state(@apply)
    assert_equal('CA', state)
  end
  
  test "state method where application doesn't have a state" do
    @person = Factory(:person, :universityState => '', :campus => 'UIUC')
    Factory(:campus)
    setup_application
    state = Factory.build(:school_picker, :question_sheet => @question_sheet, :page => @page).state(@apply)
    assert_equal('IL', state)
  end
  
  test "choices with campus populated" do
    @person = Factory(:person, :universityState => 'IL')
    campus = Factory(:campus)
    setup_application
    assert_equal(['UIUC'], SchoolPicker.new.choices(@apply))
  end
  
  test "choices with no state" do
    @person = Factory(:person)
    setup_application
    assert_equal([], Factory.build(:school_picker, :question_sheet => @question_sheet, :page => @page).choices(@apply))
  end
  
  test "validation class" do
    assert_equal('validate-selection', SchoolPicker.new(:required => true).validation_class)
    assert_equal('', SchoolPicker.new(:required => false).validation_class)
  end
end
