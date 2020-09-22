Rails.application.routes.draw do
  get 'simple', to: 'steps#simple'
  get 'sample', to: 'lists#sample'
  get 'swipe', to: 'lists#swipe'
  resources :lists
  resources :steps do
    collection do
      delete 'destroy_all'
    end
  end
  get 'example', to: 'steps#example'
  root 'users#index'
  resources :its do
    collection do
      delete 'destroy_all'
    end
  end
  get 'hint', to: 'its#hint'
  resources :macs, except: %i(index)
  get 'details', to: 'macs#details'
  resources :tasks
  resources :users
  get 'big_area', to: 'users#big_area'
  get 'index', to: 'tasks#index'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  post '/tasks/:id/toggle' => 'tasks#toggle'
  post '/steps/:id/toggle' => 'steps#toggle'
end
