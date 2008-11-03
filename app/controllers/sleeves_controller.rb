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
      redirect_to edit_sleeve_path(@sleeve)
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
      redirect_to sleeves_path
    else
      @sleeve_sheets = @sleeve.sleeve_sheets.find(:all)
      @new_sleeve_sheet = @sleeve.sleeve_sheets.build
      
      @question_sheets = QuestionSheet.find(:all, :order => 'label').map {|qs| [qs.label, qs.id]}
      @assignees = SleeveSheet.assignees
      render :action => :edit
    end
  end
  
  def destroy
    @sleeve = Sleeve.find(params[:id])
    
    unless @sleeve.applies.length > 0
      #destroy sleeve_sheets for this sleeve
      @sleeve.sleeve_sheets.each do |ss|
        ss.destroy
      end
      #destroy sleeve
      @sleeve.destroy
      redirect_to sleeves_path
    else
      @sleeves = Sleeve.find(:all)
      flash[:error] = "Applicants have applied for this application.  It cannot be deleted."
      render :action => :index
    end
  end
  
end
