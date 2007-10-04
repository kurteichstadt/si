# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include CommonEngine

  def current_person
    raise "no user" unless user
    # Get their user, or create a new one if theirs doesn't exist
    p = user.person || user.create_person_and_address
    p
  end
  
  def user
#    if session[:casfilterreceipt]
#      @user ||= User.find_by_globallyUniqueID(session[:casfilterreceipt].attributes[:ssoGuid])
#      return @user
#    end
    if session[:user_id]
      @user = User.find_by_id(session[:user_id]) unless @user
      return @user
    end
    return false unless @user
  end

  def datestamp(date)
    if !date.nil?
      h date.strftime("%m/%d/%Y") 
    else
      "-"
    end
  end
end
