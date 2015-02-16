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
  
  resources :users, only: [:create]
  get '/register', to: 'users#new'
  
  resources :sessions, only: [:create]
  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy'
  post 'login', to: 'sessions#create'
  
  
  get '/my_queue', to: 'queue_items#index'
  resources :queue_items, only: [:create, :destroy]
  
  
end
