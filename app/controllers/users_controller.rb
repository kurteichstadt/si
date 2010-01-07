class UsersController < ApplicationController
  skip_before_filter CAS::Filter, :only => [:search]
  skip_before_filter AuthenticationFilter, :only => [:search]
  before_filter :check_valid_user, :except => [:search]
  layout 'admin', :except => [:search]
  
  def index
    @users = SiUser.find(:all, :order => 'ministry_person.lastName, ministry_person.firstName', :include => {:user => :person})
  end
  
  def new
    respond_to do |format|
      format.html
    end
  end
  
  def edit
   @temp_user = SiUser.find(params[:id])
   
    respond_to do |format|
      format.html
    end
  end
  
  def create
    @temp_user = SiUser.new
    if params[:person_id].blank?
      @temp_user.errors.add_to_base "You must first select a person before creating a new user."
      render :action => :new
    else
      @person = Person.find(:first, :conditions => ['personID = ?', params[:person_id]], :include => :user)
      old_user = SiUser.find_by_ssm_id(@person.user) 
      old_user.destroy if old_user # delete the old user so we can create the new one.
      type = params[:temp_user][:role]
      @new_user = type.constantize.create!(:ssm_id => @person.user.id,
                                           :created_at => Time.now,
                                           :created_by_id => user.id,
                                           :role => type)
      redirect_to users_path
    end
  end
  
  def update
    @temp_user = SiUser.find(params[:id])
    
    respond_to do |format|
      if @temp_user.update_attributes(params[:temp_user])
        format.html { redirect_to users_path }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def destroy
    @temp_user = SiUser.find(params[:id])
    @temp_user.destroy
    
    respond_to do |format|
      format.html { redirect_to users_path }
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
    return @people
  end
end