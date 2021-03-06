Rails.application.routes.draw do

  get 'stampings/index'
  post 'stampings/go_to_work'

  get 'calendars/index'

  get 'kintai_header/edit/:id', to: 'kintai_header#edit'
  patch 'kintai_header/update/:id', to: 'kintai_header#update'

  get 'attendance_information/index'
  get 'attendance_information/create_pre_month'
  get 'attendance_information/create_next_month'

  resources :katagakis

  resources :summary_attendances do
    collection do
      get 'print'
      # get 'data_make'
      get 'check'
      get 'cancel_check'
      get 'approve'
      get 'cancel_approval'
      get 'create_pre_month'
      get 'create_next_month'
      get 'calculate'
      get 'print'
      post 'search'
    end
  end

  resources :housing_allowances do
    collection do
      get 'print'
      get 'check'
      get 'cancel_check'
      get 'approve'
      get 'cancel_approval'
      get 'create_pre_month'
      get 'create_next_month'
    end
  end

  # get 'reasons/edit'

  # get 'reasons/new'


  get 'resumes/index'
  get 'resumes/print'


  resources :commutes do
    collection do
      get 'print'
      get 'check'
      get 'cancel_check'
      get 'approve'
      get 'cancel_approval'
      get 'create_pre_month'
      get 'create_next_month'
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
      get 'check'
      get 'cancel_check'
      get 'approve'
      get 'cancel_approval'
      get 'create_pre_month'
      get 'create_next_month'
    end
  end
  # match '/freeze_up', to:'transportation_expresses#freeze_up', via: :get
  # match '/cancel_freeze', to:'transportation_expresses#cancel_freeze', via: :get
  # match '/approve', to:'transportation_expresses#approve', via: :get
  # match '/cancel_approval', to:'transportation_expresses#cancel_approval', via: :get
  # # match '/check', to:'transportation_expresses#check', via: :get
  # match '/cancel_check', to:'transportation_expresses#cancel_check', via: :get
  # #  resource :transportation_expresses, only: [] do
  # #   get :print
  # # end
  resources :vacation_requests do
    collection do
      get 'print'
      get 'check'
      get 'cancel_check'
      get 'approve'
      get 'cancel_approval'
      get 'create_pre_month'
      get 'create_next_month'
    end
  end



  resources :business_reports, only:[:index, :new, :create, :edit, :update] do
    collection do
      get 'print'
      get 'check'
      get 'cancel_check'
      get 'approve'
      get 'cancel_approval'
      get 'create_pre_month'
      get 'create_next_month'
    end
  end
  resources :business_reports


  resource :qualification_allowances, only:[] do
    get :print
  end
  resources :qualification_allowances

  match '/index_freeze', to:'papers#index_freeze', via: :get


  resources :kinmu_patterns, only:[:index, :new, :create, :edit, :update] do
    collection do
      get 'create_pre_month'
      get 'create_next_month'
    end
  end

  resources :kinmu_patterns
  resources :sections
  resources :attendances, only:[:index, :new, :create, :edit, :update] do
    collection do
      get 'print'
      get 'check'
      get 'cancel_check'
      get 'approve'
      get 'cancel_approval'
      get 'create_pre_month'
      get 'create_next_month'
    end
  end
  match '/init_attendances', to:'attendances#init_attendances', via: :get
  match '/calculate_attendance', to:'attendances#calculate', via: :get
  match '/input_attendance_time', to:'attendances#input_attendance_time', via: :get

  match '/freeze_up', to:'papers#freeze_up', via: :get
  match '/cancel_freeze', to:'papers#cancel_freeze', via: :get

  # match '/approve', to:'attendances#approve', via: :get
  # match '/cancel_approval', to:'attendances#cancel_approval', via: :get
  # match '/check', to:'attendances#check', via: :get
  # match '/cancel_check', to:'attendances#cancel_check', via: :get


  # match '/data_clear', to:'attendances#clear', via: :get

  # resources :attendances, only:[:index, :new, :create, :edit, :update] do
  #   patch :confirm, on: :member
  # end

  # match '/attendances/print', to: 'attendances#print', via: :get

  resource :attendances, only: [] do
    get :print
  end



  # get 'static_pages/home'
  match '/home', to:'static_pages#home', via: :get
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
  # ログイン画面をホームにする
  #root :to => "static_pages#home"
  devise_scope :user do
    root :to => "devise/sessions#new"
  end

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
