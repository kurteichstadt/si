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

  def calendar_date_select_tag(name, value = nil, options = {})
    options.merge!({'data-calendar' => true})
    value = case
          when value.is_a?(Time)
            l(value.to_date)
          when value.is_a?(Date)
            l(value)
          else
            value
          end
    text_field_tag(name, value, options )
  end
end
