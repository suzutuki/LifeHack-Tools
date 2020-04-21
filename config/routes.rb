Rails.application.routes.draw do
  root 'tasks#index'
  get '/signup', to: 'users#new'
  resources :tasks
  post '/tasks/:id/toggle' => 'tasks#toggle'
end
