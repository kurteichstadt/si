class InfoPagesController < ApplicationController
  skip_before_filter :cas_filter
  skip_before_filter :authentication_filter
  
  layout 'public'
  
  def index
    if user
      redirect_to show_default_path
    else  
      redirect_to :action => :home
    end
  end
  
  def home
    @active = "home"
  end

  def instructions
  end

  def faqs
    @active = "faq"
    @faq = Fe::Element.find_by(slug: 'faq') # The FAQ from the application
  end

  def about_us
    @active = "about"
  end

  def contact_us
    @active = "contact"
  end
  
  def opportunities
    @active = "opportunities"
    @national_projects = HrSiProject.where("projectType = 'n' AND siYear = ? AND (onHold <> 1 OR onHold is null)", HrSiApplication::YEAR).order("name ASC").all
    @regional_stint_projects = HrSiProject.where("projectType = 's' AND siYear = ? AND (onHold <> 1 OR onHold is null)", HrSiApplication::YEAR).order("name ASC").all
    @regional_internship_projects = HrSiProject.where("projectType = 'i' AND siYear = ? AND (onHold <> 1 OR onHold is null)", HrSiApplication::YEAR).order("name ASC").all
  end
  
  def a_real_life_story
  end
  
  def privacy_policy
    @active = "privacy"
  end
end
