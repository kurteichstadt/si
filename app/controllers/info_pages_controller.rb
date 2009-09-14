class InfoPagesController < ApplicationController
  skip_before_filter CAS::Filter
  skip_before_filter AuthenticationFilter
  
  layout 'public'
  
  def index
    if user
      redirect_to home_path
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
    @national_projects = HrSiProject.find_all_by_projectType('n', :conditions => ['siYear = ? and onHold <> \'1\'', HrSiApplication::YEAR], :order => "name ASC")
    @regional_stint_projects = HrSiProject.find_all_by_projectType('s', :conditions => ['siYear = ? and onHold <> \'1\'', HrSiApplication::YEAR], :order => "name ASC")
    @regional_internship_projects = HrSiProject.find_all_by_projectType('i', :conditions => ['siYear = ? and onHold <> \'1\'', HrSiApplication::YEAR], :order => "name ASC")
  end
  
  def a_real_life_story
  end
  
  def privacy_policy
  end
end
