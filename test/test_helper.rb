ENV["Rails.env"] = "test"
 require 'simplecov'
 SimpleCov.start 'rails' do
   add_filter "vendor"
   add_filter 'app/controllers/api'
   merge_timeout 36000
 end

require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails/test_help'

class ActiveSupport::TestCase
  include ActionController::TestProcess
  include AuthenticatedTestHelper

  fixtures :all

  def cas_login
    @si_user = Factory(:si_user)
    CAS::Filter.fake = true
    @request.session[:casfilterreceipt] = Receipt.new
  end

  def login
    @person = Factory(:person)
    @user = @person.user
    @request.session[:user_id] = @user.id
  end

  def setup_application
    @address = Factory(:address, :person => @person)
    @apply = Factory(:apply, :applicant => @person)
    @hr_si_application = Factory(:hr_si_application, :person => @person, :apply => @apply)
    @sleeve = @apply.sleeve
    @sleeve_sheet = Factory(:sleeve_sheet, :sleeve => @sleeve)
    @question_sheet = @sleeve_sheet.question_sheet
    @answer_sheet = @question_sheet.answer_sheets.create
    @page = Factory(:page, :question_sheet => @question_sheet)
    @apply.apply_sheets.create(:sleeve_sheet => @sleeve_sheet, :answer_sheet => @answer_sheet)
  end

  def setup_reference
    @ref_sheet = Factory(:ref_sheet, :sleeve => @sleeve)
    @ref_question_sheet = @ref_sheet.question_sheet
    @ref_answer_sheet = @ref_question_sheet.answer_sheets.create
    @ref_apply_sheet = Factory(:apply_sheet, :apply => @apply, :sleeve_sheet => @ref_sheet, :answer_sheet => @ref_answer_sheet)
    @ref_page = Factory(:page, :question_sheet => @ref_question_sheet)

    #Staff Reference
    @reference = Factory(:reference, :apply => @apply, :sleeve_sheet => @ref_sheet)

    @discipler_ref_sheet = Factory(:d_ref_sheet, :sleeve => @sleeve, :question_sheet => @ref_question_sheet)
    @discipler_reference = Factory(:reference, :apply => @apply, :sleeve_sheet => @discipler_ref_sheet)

    @roomate_ref_sheet = Factory(:r_ref_sheet, :sleeve => @sleeve, :question_sheet => @ref_question_sheet)
    @roomate_reference = Factory(:reference, :apply => @apply, :sleeve_sheet => @roomate_ref_sheet)

    @friend_ref_sheet = Factory(:f_ref_sheet, :sleeve => @sleeve, :question_sheet => @ref_question_sheet)
    @friend_reference = Factory(:reference, :apply => @apply, :sleeve_sheet => @friend_ref_sheet)
  end
end
