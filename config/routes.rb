Rails.application.routes.draw do

  root 'users#index'
  resources :if_thens
  resources :macs
  get 'details', to: 'macs#details'
  resources :users
  resources :tasks
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  post '/tasks/:id/toggle' => 'tasks#toggle'
end
