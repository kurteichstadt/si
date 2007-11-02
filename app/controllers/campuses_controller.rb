class CampusesController < ApplicationController
  include AuthenticatedSystem
  skip_before_filter CAS::Filter 
  skip_before_filter AuthenticationFilter
  prepend_before_filter :login_from_cookie
  
  layout nil
 
  def search
    @campuses = Campus.find_all_by_state(params[:state], :order => :name)
    current_person.update_attribute(:universityState, params[:state])
  end
end
