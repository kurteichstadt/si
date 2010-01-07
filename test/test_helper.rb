ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class ActiveSupport::TestCase
  include ActionController::TestProcess
  include AuthenticatedTestHelper
  
  fixtures :all

  def cas_login
    Factory(:si_user)
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
    Factory(:page, :question_sheet => @question_sheet)
    @apply.apply_sheets.create(:sleeve_sheet => @sleeve_sheet, :answer_sheet => @answer_sheet)
  end
  
  def setup_with_hr_si_application
    @sleeve = Factory(:sleeve)
    @address = Factory(:address, :person => @person)
    @hr_si_application = Factory(:hr_si_application, :person => @person)
    @apply = @hr_si_application.apply
    @apply.update_attribute(:sleeve, @sleeve) if @apply.sleeve.nil?
    @sleeve_sheet = Factory(:sleeve_sheet, :sleeve => @sleeve)
    @question_sheet = @sleeve_sheet.question_sheet
    @answer_sheet = @question_sheet.answer_sheets.create
    Factory(:page, :question_sheet => @question_sheet)
    @apply.apply_sheets.create(:sleeve_sheet => @sleeve_sheet, :answer_sheet => @answer_sheet)
  end
  
  def setup_reference(sleeve)
    @ref_sheet = Factory(:ref_sheet, :sleeve => sleeve)
    @ref_question_sheet = @ref_sheet.question_sheet
    @ref_answer_sheet = @ref_question_sheet.answer_sheets.create
    Factory(:page, :question_sheet => @ref_question_sheet)
    @reference = Factory(:reference, :apply => @apply, :sleeve_sheet => @ref_sheet)
  end
end
