# SchoolPicker
# - a two-part question to search for the user's school

class SchoolPicker < Question
  def state(app=nil)
    if !app.nil?
      # try to get state from the applicant
      s = app.applicant.universityState
      if s.blank?
        # get from the campus
        c = Campus.find_by_name(response)
        if !c.nil?
          s = c.state
        else
          s = ""
        end
      end
    else
      s = ""
    end
    return s
  end
  
  def choices(app=nil)
    unless self.state(app) == ""
      return Campus.find_all_by_state(self.state(app), :order => :name).to_a.collect {|c| c.name} 
    end
    []
  end
  
  def validation_class
    if self.required?
      'validate-selection'
    else
      ''
    end
  end
end