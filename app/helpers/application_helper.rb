# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include CommonEngine

  def datestamp(date)
    if !date.nil?
      h date.strftime("%m/%d/%Y") 
    else
      "-"
    end
  end
end
