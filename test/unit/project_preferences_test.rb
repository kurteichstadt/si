require 'test_helper'

class ProjectPreferencesTest < ActiveSupport::TestCase

  test "choices with application" do
    @person = Factory(:person, :universityState => 'IL', :campus => 'UIUC')
    @project = Factory(:hr_si_project, :projectType => 'n')
    campus = Factory(:campus)
    setup_application
    assert_equal([[@project.name, @project.id]], ProjectPreference.new.choices(@apply))
  end
  
  test "choices without application" do
    assert_equal([], ProjectPreference.new.choices)
  end
  
  test "display response" do
    @person = Factory(:person, :universityState => 'IL', :campus => 'UIUC')
    @project = Factory(:hr_si_project, :projectType => 'n')
    setup_application
    @project_preference = Factory(:project_preference, :question_sheet => @question_sheet, :page => @page)
    Answer.create(:question_id => @project_preference.id, :answer_sheet_id => @answer_sheet.id, :value => @project.id.to_s)
    assert_equal('Italy:Rome', @project_preference.display_response(@apply))
  end
  
  test "display response with no location" do
    @person = Factory(:person, :universityState => 'IL', :campus => 'UIUC')
    @project = Factory(:hr_si_project, :projectType => 'n')
    setup_application
    @project_preference = Factory(:project_preference, :question_sheet => @question_sheet, :page => @page)
    assert_equal('', @project_preference.display_response(@apply))
  end
  
end
