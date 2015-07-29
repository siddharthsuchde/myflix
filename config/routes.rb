Myflix::Application.routes.draw do
  
  root to: 'pages#front'
  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'videos#index'
  
  resources :videos, only: [:show] do
    resources :categories, only: [:index]
    collection do
      get 'search', to: 'videos#search'
    end
    resources :reviews, only: [:create]
  end
  
  resources :categories, only: [:show]
  
  resources :users, only: [:create, :show] 
  get '/register', to: 'users#new'
  
  get 'people', to: 'relationships#index'
  resources :relationships, only: [:destroy, :create]
  
  resources :sessions, only: [:create]
  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy'
  post 'login', to: 'sessions#create'
  
  
  get '/my_queue', to: 'queue_items#index'
  post 'update_queue', to: 'queue_items#update_queue'
  resources :queue_items, only: [:create, :destroy, :update]
  
  get 'forgot_password', to: 'forgot_passwords#new'
  resources :forgot_passwords, only: [:create]
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirmation'
  
  resources :password_reset, only: [:show]
  
  
end
