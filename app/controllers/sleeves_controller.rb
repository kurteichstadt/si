class SleevesController < ApplicationController
  layout 'admin'  
  
  def index
    @sleeves = Sleeve.find(:all)
  end
  
  def new
    @sleeve = Sleeve.new
  end
  
  def create
    @sleeve = Sleeve.new(params[:sleeve])

    if @sleeve.save
      flash[:notice] = "Application successfully created."
      redirect_to edit_sleeve_url(@sleeve)
    else
      render :action => :new
    end
  end
  
  def edit
    @sleeve = Sleeve.find(params[:id])
    @sleeve_sheets = @sleeve.sleeve_sheets.find(:all)
    @new_sleeve_sheet = @sleeve.sleeve_sheets.build
    
    @question_sheets = QuestionSheet.find(:all, :order => 'label').map {|qs| [qs.label, qs.id]}
    @assignees = SleeveSheet.assignees
  end
  
  def update
    @sleeve = Sleeve.find(params[:id])

    if @sleeve.update_attributes(params[:sleeve])
      flash[:notice] = "Application updated."
      redirect_to sleeves_url
    else
      @sleeve_sheets = @sleeve.sleeve_sheets.find(:all)
      @new_sleeve_sheet = @sleeve.sleeve_sheets.build
      
      @question_sheets = QuestionSheet.find(:all, :order => 'label').map {|qs| [qs.label, qs.id]}
      @assignees = SleeveSheet.assignees
      render :action => :edit
    end
  end
  
end
