Rails.application.routes.draw do
  resources :artists
  resources :albums
  resources :genres, only: %i[index new create edit update show destroy]
  
  root 'pages#home'
  get 'home', to: 'pages#home', as: 'home'
  get "up" => "rails/health#show", as: :rails_health_check
  get 'about', to: 'pages#about' 
  get '/genres/index', to: 'genres#index'
end
