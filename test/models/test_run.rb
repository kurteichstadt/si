require 'test_helper'

class RunTest < ActiveSupport::TestCase

  test "daily tasks" do
    create(:payment, :status => 'Approved')
    Run.daily_tasks
  end
  
  test "change si year" do
    HrSiProject.delete_all
    create(:hr_si_project, :siYear => HrSiApplication::YEAR - 1)
    assert_no_difference "HrSiProject.count(:conditions => {:siYear => HrSiApplication::YEAR - 1})" do
      assert_difference "HrSiProject.count(:conditions => {:siYear => HrSiApplication::YEAR})", 1 do
        Run.change_si_year
      end
    end
  end
end
