class InfoPagesController < ApplicationController
  skip_before_filter CAS::Filter
  skip_before_filter AuthenticationFilter
  
  layout 'public'
  
  def index
    if user
      redirect_to show_default_path
    else  
      redirect_to :action => :home
    end
  end
  
  def home
  end

  def instructions
  end

  def faqs
  end

  def about_us
  end

  def contact_us
  end
  
  def opportunities
    @national_projects = HrSiProject.where("projectType = 'n' AND siYear = ? AND (onHold <> 1 OR onHold is null)", HrSiApplication::YEAR).order("name ASC").all
    @regional_stint_projects = HrSiProject.where("projectType = 's' AND siYear = ? AND (onHold <> 1 OR onHold is null)", HrSiApplication::YEAR).order("name ASC").all
    @regional_internship_projects = HrSiProject.where("projectType = 'i' AND siYear = ? AND (onHold <> 1 OR onHold is null)", HrSiApplication::YEAR).order("name ASC").all
  end
  
  def a_real_life_story
  end
  
  def privacy_policy
  end
end
