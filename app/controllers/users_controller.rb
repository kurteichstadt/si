class UsersController < ApplicationController
  skip_before_filter CAS::Filter, :only => [:search]
  skip_before_filter AuthenticationFilter, :only => [:search]
  layout 'admin', :except => [:search]
  
  def index
    @users = SiUser.find(:all, :order => 'lastName, firstName', :include => {:user => :person})
  end
  
  def new
    respond_to do |format|
      format.html
    end
  end
  
  def edit
    respond_to do |format|
      format.html
    end
  end
  
  def create
    @person = Person.find(:first, :conditions => ['personID = ?', params[:person_id]], :include => :user)
    old_user = SiUser.find_by_ssm_id(@person.user) 
    old_user.destroy if old_user # delete the old user so we can create the new one.
    type = params[:user][:role]
    @new_user = type.constantize.create!(:ssm_id => @person.user.id,
                                         :created_at => Time.now,
                                         :created_by_id => user.id)

    redirect_to users_url
  end
  
  def update
    respond_to do |format|
      format.html
    end
  end
  
  def search
    @name = params[:name]
    @people = person_search(params[:name])
    render :layout => false
  end
  
  protected
    def person_search(name, options = {})
    @people = Array.new
    if name and !name.empty?
      names = name.strip.split(' ')
      if (names.size > 1)
        first = names[0]
        last = names[1].empty? ? first : names[1]
        @conditions = [ "lastName LIKE ? AND firstName LIKE ? ", last + "%", first + "%" ]
      else
        name = names.join
        @conditions = [ "(lastName LIKE ? OR firstName LIKE ?) ", name+'%',name+'%' ]
      end
      @conditions[0] += " AND fk_ssmUserId <> 0 AND fk_ssmUserId is NOT NULL " if !options[:all_users]
      @conditions[0] += " AND accountNo <> '' AND accountNo is NOT NULL " if options[:staff_only]
      @people = Person.find(:all, :order => "lastName, firstName", :conditions => @conditions)
    end
  end
end