Rails.application.routes.draw do
  get 'users/new'

  root 'tasks#index'
  get '/signup', to: 'users#new'
  resources :tasks
  post '/tasks/:id/toggle' => 'tasks#toggle'
end
