Rails.application.routes.draw do
  
  get 'sessions/new'

  root 'tasks#index'
  get 'users/new'
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :tasks
  resources :users
  
  post '/tasks/:id/toggle' => 'tasks#toggle'
end
