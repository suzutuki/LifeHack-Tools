Rails.application.routes.draw do
  root 'users#index'
  resources :macs
  resources :users
  resources :tasks
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  post '/tasks/:id/toggle' => 'tasks#toggle'
end
