Rails.application.routes.draw do

  root 'users#index'
  resources :if_thens
  resources :macs, except: %i(index)
  get 'details', to: 'macs#details'
  resources :tasks, except: %i(index)
  resources :users
  get 'ivy', to: 'tasks#ivy'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  post '/tasks/:id/toggle' => 'tasks#toggle'
end
