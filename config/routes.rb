Rails.application.routes.draw do
  resources :albums
  resources :genres, only: %i[index new create edit update show]
  
  get "up" => "rails/health#show", as: :rails_health_check
  root 'pages#home'
  get 'about', to: 'pages#about' 
  get '/genres/index', to: 'genres#index'
end
