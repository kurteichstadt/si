class AccountController < ApplicationController
  include AuthenticatedSystem
  skip_before_filter CAS::Filter 
  skip_before_filter AuthenticationFilter
  prepend_before_filter :login_from_cookie
#  before_filter :prod_check, :except => [:closed, :secret_hooey]
  filter_parameter_logging :password

  def index
    redirect_to(:action => 'login')
  end

  def login
    self.current_user ||= User.authenticate(params[:username], params[:password]) if params[:username] && params[:password]
    if current_user
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_back_or_default(post_login)
      flash[:notice] = "Logged in successfully"
    else
      flash[:notice] = "Invalid username/password" if params[:username]
    end
  end

  def signup
    @user = User.new(params[:user])
    @person = Person.new(params[:person])
    return unless request.post?
    @user.valid?
    if @person.firstName.to_s.strip.empty? || @person.lastName.to_s.strip.empty?
      @user.errors.add_to_base "Please enter your first and last name."
      @person.errors.add(:firstName, "can't be blank.") if @person.firstName.to_s.empty?
      @person.errors.add(:lastName, "can't be blank.") if @person.lastName.to_s.empty?
    end
    unless @user.errors.empty?
      render :action => 'signup'
    else
      @user.save
      @person = @user.create_person_and_address(params[:person])
      self.current_user = @user
      redirect_back_or_default(:action => 'login')
      flash[:notice] = "Thanks for signing up!"
    end
  end
  
  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(login_path)
  end
  
  def post_login
    {:controller => 'applications', :action => 'show_default'}
  end
  
  
  def prod_check
    if ENV['RAILS_ENV'] == "production"
      redirect_to :action => :closed
    end
  end

  def secret_hooey
    login
    render :action => :login
  end
end
