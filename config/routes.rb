Myflix::Application.routes.draw do
  
  root to: 'videos#index'
  get 'ui(/:action)', controller: 'ui'
  
  resources :videos, only: [:show] do
    resources :categories, only: [:index]
  end
  
  resources :categories, only: [:show]
  
end
