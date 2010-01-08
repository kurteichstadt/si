require 'test_helper'

class AnswerTest < ActiveSupport::TestCase

  test "answer updates person object" do
    @person = Factory(:person)
    setup_application
    element = Factory(:element, :object_name => 'applicant', :attribute_name => 'firstName', :page => @page, :question_sheet => @question_sheet)
    answer = Answer.new(:answer_sheet_id => @answer_sheet.id, :question_id => element.id, :value => 'Justin')
    assert_equal('GI', answer.application.applicant.firstName)
    answer.save
    assert_equal('Justin', answer.application.applicant.firstName)
    assert(answer.new_record?, "Answer was saved when it shouldn't have been")
  end
end
