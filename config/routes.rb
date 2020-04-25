Rails.application.routes.draw do
  
  root 'users#index'
  get 'sessions/new'
  get 'users/new'
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :tasks   
  # only: [:create, :destroy, :edit ]
  resources :users
  post '/tasks/:id/toggle' => 'tasks#toggle'
end
