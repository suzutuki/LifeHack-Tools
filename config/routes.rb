Rails.application.routes.draw do
  resources :hiits
  root 'users#index'
  resources :its do
    collection do
      delete 'destroy_all'
    end
  end
  resources :macs
  resources :tasks do
    collection do
      delete 'destroy_all'
    end
  end
  resources :users
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/easy_login', to: 'users#easy_login'
  delete '/logout', to: 'sessions#destroy'
  post '/tasks/:id/toggle' => 'tasks#toggle'
  get '/about', to: 'users#about'
end
