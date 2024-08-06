Rails.application.routes.draw do
  resources :artists
  resources :albums, only: %i[index show new create edit update destroy]
  resources :genres
  
  root 'pages#home'

  get 'home', to: 'pages#home', as: 'home'
  get 'about', to: 'pages#about' 

  get '/home', to: 'albums#home'
  
  post '/', to: 'albums#home'
end
