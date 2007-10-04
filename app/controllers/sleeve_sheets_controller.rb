# Used to add sheets to a sleeve in the "Edit Application" interface
class SleeveSheetsController < ApplicationController

  before_filter :setup
  
  # add a sheet to a specific sleeve
  def create
    @sleeve_sheet = @sleeve.sleeve_sheets.build(params[:sleeve_sheet])
    
    if @sleeve_sheet.save
      render :update do |page|
        page.insert_html :bottom, 'sleeve_sheets', :partial => 'sheet', :object => @sleeve_sheet
        page.call %{$('new_sleeve_sheet_form').reset}
        page.visual_effect(:highlight, dom_id(@sleeve_sheet), :duration => 0.5)
      end
    else
      # not valid
      render :update do |page|
        page[:new_sleeve_sheet].visual_effect :highlight, :startcolor => '#ffffff', :endcolor => "#990000", :duration => 0.5
      end
    end
  end
  
  # return read-only (for 'cancel')
  def show
    @sleeve_sheet = @sleeve.sleeve_sheets.find(params[:id])
    render :update do |page|
      page.replace dom_id(@sleeve_sheet), :partial => 'sheet', :object => @sleeve_sheet
    end
  end
  
  # return editable form
  def edit
    @sleeve_sheet = @sleeve.sleeve_sheets.find(params[:id])
    
    @question_sheets = QuestionSheet.find(:all, :order => 'label').map {|qs| [qs.label, qs.id]}
    @assignees = SleeveSheet.assignees
    
    render :update do |page|
      page.replace dom_id(@sleeve_sheet), :partial => 'edit_sheet', :object => @sleeve_sheet
    end
  end
  
  # save changes to a sleeve sheet
  def update
    @sleeve_sheet = @sleeve.sleeve_sheets.find(params[:id])
    if @sleeve_sheet.update_attributes(params[:sleeve_sheet])
      # change back to read only mode
      render :update do |page|
        page.replace dom_id(@sleeve_sheet), :partial => 'sheet', :object => @sleeve_sheet
        page.visual_effect :highlight, dom_id(@sleeve_sheet), :duration => 0.5
      end
    else
      render :update do |page|
        page.visual_effect(:highlight, dom_id(@sleeve_sheet), :startcolor => '#ffffff', :endcolor => "#990000", :duration => 0.5)
      end
    end
  end
  
  # remove a sheet
  def destroy
    @sleeve_sheet = @sleeve.sleeve_sheets.find(params[:id])
    if @sleeve_sheet && @sleeve_sheet.destroy
      render :update do |page|
        page.visual_effect :fade, dom_id(@sleeve_sheet)        
      end
    else
      render :nothing => true, :status => 500
    end
  end




  private
  
  def setup
    @sleeve = Sleeve.find(params[:sleeve_id])
  end
  
end
