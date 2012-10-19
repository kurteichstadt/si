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
  
  match '/info_pages/a_real_life_story' => 'info_pages#a_real_life_story'
  match '/info_pages/about_us' => 'info_pages#about_us'
  match '/info_pages/contact_us' => 'info_pages#contact_us'
  match '/info_pages/faqs' => 'info_pages#faqs'
  match '/info_pages/home' => 'info_pages#home'
  match '/info_pages/index' => 'info_pages#index'
  match '/info_pages/instructions' => 'info_pages#instructions'
  match '/info_pages/opportunities' => 'info_pages#opportunities'
  match '/info_pages/privacy_policy' => 'info_pages#privacy_policy'

  root :to => "info_pages#index"
  
#  resource :sleeves do
#    resources :sheets, :controller => :sleeve_sheets, :name_prefix => 'sleeve_'
#  end

  match 'applications/show_default' => 'applications#show_default', :as => 'show_default'
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
