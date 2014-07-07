Si::Application.routes.draw do
  # copied from common engine
  match '/auth/:provider/callback' => 'authentications#create', via: :get
  match '/auth/failure' => 'authentications#failed', via: :get
  resources :authentications
  resource :session do
    get :send_password_email
    post :send_password_email
  end
  resources :users do
    collection do
      get :reset_password
    end
  end
  match '/login' => "sessions#new", :as => :login, via: :get
  match '/logout' => "sessions#destroy", :as => :logout, via: [:get, :post, :delete]

  ####

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
    end
  end
  
  resources :users do
    collection do
      post :search
    end
  end
  
#  match 'account/login' => "account#login", :as => :login
#  match 'account/logout' => "account#logout", :as => :logout
#  match 'account/signup' => "account#signup", :as => :signup
  
  resources :authentications

  match '/auth/:provider/callback' => 'authentications#create', via: [:get, :post]
  match '/auth/failure' => 'authentications#failed', via: [:get, :post]

  match 'admin' => "admin#index", :as => :admin_home, via: [:get, :post]
  match 'admin/select_region' => 'admin#select_region', :via => :post, :as => :select_region
  match 'admin/no_access' => 'admin#no_access', via: [:get, :post]
  match 'admin/logout' => 'admin#logout', :as => :admin_logout, via: :get

  match '/info_pages/a_real_life_story' => 'info_pages#a_real_life_story', via: [:get, :post]
  match '/info_pages/about_us' => 'info_pages#about_us', via: [:get, :post]
  match '/info_pages/contact_us' => 'info_pages#contact_us', via: [:get, :post]
  match '/info_pages/faqs' => 'info_pages#faqs', via: [:get, :post]
  match '/info_pages/home' => 'info_pages#home', via: [:get, :post]
  match '/info_pages/index' => 'info_pages#index', via: [:get, :post]
  match '/info_pages/instructions' => 'info_pages#instructions', via: [:get, :post]
  match '/info_pages/opportunities' => 'info_pages#opportunities', via: [:get, :post]
  match '/info_pages/privacy_policy' => 'info_pages#privacy_policy', via: [:get, :post]

  root :to => "info_pages#index"
  
#  resource :sleeves do
#    resources :sheets, :controller => :sleeve_sheets, :name_prefix => 'sleeve_'
#  end
end
