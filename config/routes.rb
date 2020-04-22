Rails.application.routes.draw do
  
  root 'tasks#index'
  get 'users/new'
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  resources :tasks
  resources :users
  post '/tasks/:id/toggle' => 'tasks#toggle'
end
