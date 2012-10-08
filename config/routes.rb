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
  
  match 'payment_pages/staff_search' => 'payment_pages#staff_search', :as => :payment_page_staff_search

  resources :authentications

  match '/auth/:provider/callback' => 'authentications#create'
  match '/auth/failure' => 'authentications#failed'

  match 'admin' => "admin#index", :as => :admin_home
  match 'admin/select_region' => 'admin#select_region', :via => :post, :as => :select_region
  match 'admin/no_access' => 'admin#no_access'
#  match 'admin/logout' => 'admin#logout', :as => :admin_logout

  match '/references/done' => "reference_sheets#done"

  root :to => "applications#show_default"
  
#  resource :sleeves do
#    resources :sheets, :controller => :sleeve_sheets, :name_prefix => 'sleeve_'
#  end

  resources :applications do
    member do
      get :no_ref
      get :no_conf
      get :collated_refs
      get :done
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

    resources :payments do
      member do
        get :approve
      end
      collection do
        post :staff_search
      end
    end

    resource :submit_page do
      member do
        post :submit
      end
    end
  end
end
