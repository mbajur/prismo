Rails.application.routes.draw do
  default_url_options Rails.application.config.action_mailer.default_url_options

  devise_for :users, controllers: {
    registrations: "users/registrations"
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  get :recent, to: "posts#recent", as: :recent_posts

  resource :user, path: "@:username" do
    post :follow, on: :member
    post :unfollow, on: :member

    resources :posts, path: "/", only: [ :index ], controller: "users/posts" do
      get :recent, on: :collection
    end

    resources :comments, only: [ :index ], controller: "users/comments" do
      get :recent, on: :collection
    end
  end

  resources :posts do
    post :like, on: :member
    post :unlike, on: :member
    post :scrap_url, on: :collection

    resource :flag, only: %i[new create edit update]

    resources :comments, only: [ :show, :edit, :update, :new, :create ] do
      resources :comments, only: [ :new, :create ]
    end
  end

  resources :comments do
    get :recent, on: :collection
    post :like, on: :member
    post :unlike, on: :member

    resource :flag, only: %i[new create edit update]
  end

  resources :tags, param: :name, only: [ :index ] do
    resources :posts, path: "/", controller: "tags/posts", only: [ :index ] do
      get :recent, on: :collection
    end
  end

  namespace :search do
    resources :posts, path: "/", only: [ :index ]
    resources :comments, only: [ :index ]
    resources :users, only: [ :index ]
  end

  namespace :settings do
    resource :profile, only: [ :show, :update, :destroy ]
    resource :preferences, only: [ :show, :update ]
  end


  namespace :admin do
    resource :settings, only: [ :edit, :update ]
    resources :users, except: [ :edit, :update, :destroy ] do
      post :suspend, on: :member
      post :silence, on: :member
      post :unsilence, on: :member
    end
    resources :domain_blocks, except: [ :edit, :update ]
    resources :flags, except: [ :new, :create, :destroy ] do
      post :resolve, on: :member
      post :unresolve, on: :member
    end
  end

  mount Fedipub::Engine => "/"

  # Defines the root path route ("/")
  # root "posts#index"
  root to: "posts#index"
end
