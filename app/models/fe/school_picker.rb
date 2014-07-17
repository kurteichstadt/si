# SchoolPicker
# - a two-part question to search for the user's school
class Fe::SchoolPicker < Fe::Question
  def state(app=nil)
    if !app.nil?
      # try to get state from the applicant
      state = app.applicant.universityState
      unless state.present?
        # get from the campus
        name = response(app)
        campus = Campus.find_by_name(name)
        if campus.present?
          state = campus.state
        end
      end
    end
    state.to_s
  end

  def colleges(app=nil)
    unless state(app) == ""
      return Campus.where("state = ?", self.state(app)).where("type = 'College'")
        .where("isClosed is null or isClosed <> 'T'").order(:name).to_a.collect {|c| c.name}
    end
    []
  end

  def high_schools(app=nil)
    unless state(app) == ""
      return Campus.find_all_by_type('HighSchool', :order => :name).to_a.collect {|c| c.name}
    end
    []
  end

  def validation_class(answer_sheet = nil)
    if required?(answer_sheet)
      'validate-selection' + super
    else
      ''
    end
  end
end
