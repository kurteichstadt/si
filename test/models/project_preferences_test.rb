require 'test_helper'

class ProjectPreferencesTest < ActiveSupport::TestCase

  test "choices with application" do
    @person = create(:person, :universityState => 'IL', :campus => 'UIUC')
    @project = create(:hr_si_project, :projectType => 'n')
    campus = create(:campus)
    setup_application
    assert ProjectPreference.new.choices(@apply).include?([@project.name, @project.id])
  end
  
  test "choices without application" do
    assert_equal([], ProjectPreference.new.choices)
  end
  
  test "display response" do
    @person = create(:person, :universityState => 'IL', :campus => 'UIUC')
    @project = create(:hr_si_project, :projectType => 'n')
    setup_application
    @project_preference = create(:project_preference)
    @page.elements << @project_preference
    @project_preference.set_response(@project.id.to_s, @answer_sheet)
    assert_equal('Italy:Rome', @project_preference.display_response(@answer_sheet))
  end
  
  test "display response with no location" do
    @person = create(:person, :universityState => 'IL', :campus => 'UIUC')
    @project = create(:hr_si_project, :projectType => 'n')
    setup_application
    @project_preference = create(:project_preference)
    assert_equal('', @project_preference.display_response(@apply))
  end
  
  test "display response with deleted location" do
    @person = create(:person, :universityState => 'IL', :campus => 'UIUC')
    setup_application
    @project_preference = create(:project_preference)
    @page.elements << @project_preference
    @project_preference.set_response('0', @answer_sheet)
    assert_equal("<span class='answerwarn'><b>Applicant's location preference is closed and is no longer being offered as a project.</b></span>", @project_preference.display_response(@answer_sheet))
  end
end
