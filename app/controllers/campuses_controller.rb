class CampusesController < ApplicationController
  before_filter :ssm_login_required
  
  layout nil
  respond_to :js
 
  def search
    # @campuses = Campus.find_all_by_state(params[:state], :order => :name)
    current_person.update_attribute(:universityState, params[:state]) if params[:state].present?
    @application = Fe::Application.find(params[:id])
    @school_picker = Fe::SchoolPicker.find(params[:dom_id].split('_').last)
    #respond_with(@application, @school_picker)
  end
end
