Si::Application.routes.draw do
  map.resources :email_templates
  map.resources :campuses, :collection => {:search  => :post}
  map.resources :hr_si_projects, :collection => {:search => :post, :get_valid_projects => :post, :projects_feed => :get, :show => :get}
  map.resources :users, :collection => {:search => :post}
  
  map.login 'account/login', :controller => "account", :action => "login"
  map.logout 'account/logout', :controller => "account", :action => "logout"
  map.signup 'account/signup', :controller => "account", :action => "signup"
  map.admin_home 'admin/', :controller => "admin", :action => 'index'   # could possibly be a singular resource?
  map.home '', :controller => "applications", :action => 'show_default'
  
  map.resources :sleeves, 
    :singular => :sleeve  do |sleeves| # where does it get sleeve from?? (defect is closed: http://dev.rubyonrails.org/ticket/8263)
      sleeves.resources :sheets,
        :controller => :sleeve_sheets,
        :name_prefix => 'sleeve_'
  end

  map.resources :applications, :member => {:no_ref => :get, :no_conf => :get, :collated_refs => :get} do |applications|
    applications.resources :references, :member => {:print => :get, :submit => :post, :send_invite => :post}
    # custom pages (singular resources)
    applications.resource :reference_page
    applications.resource :payment_page, :collection => {:staff_search => :post}
    applications.resource :submit_page, :member => { :submit => :post }
    applications.resources :payments, :member => {:approve => :post }
  end
end
