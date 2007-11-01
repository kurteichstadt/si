# override some methods from Questionnaire plugin to enable Application-level handling
class AnswerPagesController < ApplicationController
  skip_before_filter CAS::Filter 
  skip_before_filter AuthenticationFilter
  
  # edit page
  # note: this overrides even when accessing form via /answer_sheets/ route
  def edit
    answer_sheet = AnswerSheet.find(params[:answer_sheet_id])
    
    # do all this just so that next_page will work
    @application = answer_sheet.apply_sheet.apply
    
    sleeve_sheet = answer_sheet.apply_sheet.sleeve_sheet
    if sleeve_sheet.assign_to == 'applicant'    # get all sheets assigned to applicant
      apply_sheets = @application.apply_sheets.find(:all, :include => :sleeve_sheet, :conditions => ["#{SleeveSheet.table_name}.assign_to = ?", 'applicant'])    
      custom_pages = custom_pages(@application)
    else  # get single (reference) sheet
      apply_sheets = @application.apply_sheets.find(:all, :conditions => ["sleeve_sheet_id = ?", sleeve_sheet])
      custom_pages = nil  # no custom pages for reference
    end
    answer_sheets = apply_sheets.map {|a| a.answer_sheet}
    
    @presenter = AnswerPagesPresenter.new(self, answer_sheets, custom_pages)
    
    @presenter.active_answer_sheet = answer_sheet
    @elements = @presenter.questions_for_page(params[:id]).elements

    render :partial => 'answer_page', :locals => { :show_first => nil }
  end
  
  
  
end