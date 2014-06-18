Rails.application.routes.draw do
  
  # get 'reasons/edit'

  # get 'reasons/new'

  get 'resumes/index'
  get 'resumes/print'
  

  resources :commutes do
    collection do
      get 'print'
    end
  end
  resources :reasons

  resources :attendance_others

  resources :licenses
  resources :projects
  
  resources :transportation_expresses do
     collection do
      post 'transportation_confirm'
      get 'print'
    end
  end
  #  resource :transportation_expresses, only: [] do
  #   get :print
  # end

  resource :vacation_requests, only:[] do
    get :print
  end
  resources :vacation_requests



  resource :business_reports, only:[] do
    get :print
  end
  resources :business_reports

  # map.resources :vacation_requests, :except=> ['print']

  resources :kinmu_patterns
  resources :sections
  resources :attendances, only:[:index, :new, :create, :edit, :update]
  match '/init_attendances', to:'attendances#init_attendances', via: :get
  
  # resources :attendances, only:[:index, :new, :create, :edit, :update] do
  #   patch :confirm, on: :member
  # end
  
  # match '/attendances/print', to: 'attendances#print', via: :get

  resource :attendances, only: [] do
    get :print
  end
  


  # get 'static_pages/home'

  match '/help', to:'static_pages#help', via: :get
  match '/about', to:'static_pages#about', via: :get
  # match '/vacation_requests/print', to:'vacation_requests#print', via: :get

  devise_for :users, :controllers => {
    :sessions      => "users/sessions",
    :registrations => "users/registrations",
    :passwords     => "users/passwords"
  }

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'static_pages#home'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
