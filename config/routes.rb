Rails.application.routes.draw do

  root 'users#index'
  get 'simple', to: 'steps#simple'
  get 'sample', to: 'lists#sample'
  get 'swipe', to: 'lists#swipe'
  resources :lists
  resources :steps do
    collection do
      delete 'destroy_all'
    end
  end
  post 'goal_create', to: 'steps#goal_create'
  get 'goal', to: 'steps#goal'
  get 'example', to: 'steps#example'

  resources :its do
    collection do
      delete 'destroy_all'
    end
  end
  get 'hint', to: 'its#hint'
  resources :macs
  resources :tasks do
    collection do
      delete 'destroy_all'
    end
  end
  resources :users
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  post '/tasks/:id/toggle' => 'tasks#toggle'
  post '/steps/:id/toggle' => 'steps#toggle'









end
