Si::Application.routes.draw do
  resources :email_templates
  
  resources :campuses do
    collection do
      post :search
    end
  end
  
  resources :hr_si_projects do
    collection do 
      post :search
      post :get_valid_projects
      get :projects_feed
      get :show
    end
  end
  
  resources :users do
    collection do
      post :search
    end
  end
  
  match 'account/login' => "account#login", :as => :login
  match 'account/logout' => "account#logout", :as => :logout
  match 'account/signup' => "account#signup", :as => :signup
  match 'admin/' => "admin#index", :as => :admin_home   # could possibly be a singular resource?
  root :to => "applications#show_default", :as => :home
  
  resource :sleeves do
    resources :sheets, :controller => :sleeve_sheets, :name_prefix => 'sleeve_'
  end

  resources :applications do
    member do
      get :no_ref
      get :no_conf
      get :collated_refs
    end
    
    resources :references do
      member do
        get :print
        post :submit
        post :send_invite
      end
    end
    
    # custom pages (singular resources)
    resource :reference_page
    resource :payment_page do
      collection do
        post :staff_search
      end
    end
    resource :submit_page do
      member do
        post :submit
      end
    end
    
    resources :payments do
      member do
        post :approve
      end
    end
  end
end
