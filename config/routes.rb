ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  #map.connect ':controller/service.wsdl', :action => 'wsdl'

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
  
  
  # Install the default route as the lowest priority.
  # (don't want these in production)
  #map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
