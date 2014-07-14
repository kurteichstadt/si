require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

end

ENV["Rails.env"] = "test"
ENV["RAILS_ENV"] = "test"

require 'simplecov'
SimpleCov.start 'rails' do
  add_filter "vendor"
  add_filter 'app/controllers/api'
  merge_timeout 36000
end

require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails/test_help'

require 'authenticated_test_helper'
class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
  include AuthenticatedTestHelper
  include FactoryGirl::Syntax::Methods

  #fixtures :all

  def cas_login
    @person = create(:person)
    @user = @person.user
    @si_user = create(:si_user, user: @user)
    @request.session[:cas_user] = @si_user.user.username
    @request.session[:user_id] = @si_user.user.id
  end

  def login
    @person = create(:person)
    @user = @person.user
    @request.session[:user_id] = @user.id
  end

  def setup_application
    @address = create(:address, :person => @person)
    @question_sheet = create(:question_sheet)
    @application = create(:application, :applicant => @person)
    @answer_sheet = @application
    @page = create(:page, :question_sheet => @question_sheet)
    create(:answer_sheet_question_sheet, :question_sheet => @question_sheet, :answer_sheet => @application)
  end

  def setup_reference
    @ref_question = create(:ref_question, style: 'staff')
    @ref_question_sheet = @ref_question.related_question_sheet
    @ref_answer_sheet = create(:reference, :applicant_answer_sheet => @application, :question => @ref_question)
    @ref_page = create(:page, :question_sheet => @ref_question_sheet)

    #Staff Reference
    @reference = @ref_answer_sheet

    @discipler_ref_question = create(:ref_question, style: 'discipler')
    @discipler_reference = create(:reference, :applicant_answer_sheet => @application, :question => @discipler_ref_question)

    @roommate_ref_question = create(:ref_question, style: 'roommate')
    @roommate_reference = create(:reference, :applicant_answer_sheet => @application, :question => @roommate_ref_question)

    @friend_ref_question = create(:ref_question, style: 'friend')
    @friend_reference = create(:reference, :applicant_answer_sheet => @application, :question => @friend_ref_question)
  end
end


Spork.each_run do
  # This code will be run each time you run your specs.

end

# --- Instructions ---
# Sort the contents of this file into a Spork.prefork and a Spork.each_run
# block.
#
# The Spork.prefork block is run only once when the spork server is started.
# You typically want to place most of your (slow) initializer code in here, in
# particular, require'ing any 3rd-party gems that you don't normally modify
# during development.
#
# The Spork.each_run block is run each time you run your specs.  In case you
# need to load files that tend to change during development, require them here.
# With Rails, your application modules are loaded automatically, so sometimes
# this block can remain empty.
#
# Note: You can modify files loaded *from* the Spork.each_run block without
# restarting the spork server.  However, this file itself will not be reloaded,
# so if you change any of the code inside the each_run block, you still need to
# restart the server.  In general, if you have non-trivial code in this file,
# it's advisable to move it into a separate file so you can easily edit it
# without restarting spork.  (For example, with RSpec, you could move
# non-trivial code into a file spec/support/my_helper.rb, making sure that the
# spec/support/* files are require'd from inside the each_run block.)
#
# Any code that is left outside the two blocks will be run during preforking
# *and* during each_run -- that's probably not what you want.
#
# These instructions should self-destruct in 10 seconds.  If they don't, feel
# free to delete them.



require 'mocha/setup'
