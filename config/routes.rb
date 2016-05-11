Myflix::Application.routes.draw do
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  
  root to: 'pages#front'
  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'videos#index'
  
  namespace :admin do
    resources :videos, only: [:new, :create]
  end
  
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
  get '/register/:token', to: 'users#new_with_invitation_token', as: 'register_with_token'
  
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
  
  resources :password_resets, only: [:show, :create]
  get 'expired_token', to: 'pages#expired_token'
  
  resources :invitations, only: [:new, :create]
  
  
end


  




