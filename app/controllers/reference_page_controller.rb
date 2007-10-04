# gather reference information from Applicant
class ReferencePageController < ApplicationController
  skip_before_filter CAS::Filter
  skip_before_filter AuthenticationFilter
  
  layout nil
  
  before_filter :setup
  helper :answer_pages
  
  MONTHS_KNOWN_OPTIONS = [
    ["3 months", 3],
    ["6 months", 6],
    ["1 year", 12],
    ["2 years", 24],
    ["3 or more years", 36]
  ]
  
  # Allow applicant to edit reference
  # /applications/1/reference_page;edit
  # js: provide a partial to replace the answer_sheets page area
  # html?: return a full page for editing reference independantly (after submission)
  def edit
    @references = @application.reference_sheets
    
    # NEXT: skipping all the fancy answer sheets stuff since all custom pages come after those
    @next_page = next_custom_page(@application, 'reference_page')
  end
  
  def update
    @references = @application.reference_sheets.index_by(&:sleeve_sheet_id)
    
    params[:references].each do |sleeve_sheet_id, data|
      sleeve_sheet_id = sleeve_sheet_id.to_i
      # @references[sleeve_sheet_id] ||= @application.references.build(:sleeve_sheet_id => sleeve_sheet_id) # new reference if needed
      @references[sleeve_sheet_id].attributes = data  # store posted data
      @references[sleeve_sheet_id].save! 
    end
    
    head :ok
  end
  
  private
  def setup
    @application = Apply.find(params[:application_id])
  end  
  
end
