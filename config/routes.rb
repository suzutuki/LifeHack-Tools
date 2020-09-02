Rails.application.routes.draw do

  resources :lists
  resources :steps
  get 'example', to: 'steps#example'
  root 'users#index'
  resources :its
  get 'hint', to: 'its#hint'
  resources :macs, except: %i(index)
  get 'details', to: 'macs#details'
  resources :tasks, except: %i(index)
  resources :users
  get 'big_area', to: 'users#big_area'
  get 'ivy', to: 'tasks#ivy'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  post '/tasks/:id/toggle' => 'tasks#toggle'
end
