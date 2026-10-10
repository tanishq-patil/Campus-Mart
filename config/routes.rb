Rails.application.routes.draw do
  root "welcome#index"

  # Authentication & Sessions
  resource :session, only: %i[new create destroy]
  get "login" => "sessions#new", as: :login
  delete "logout" => "sessions#destroy", as: :logout

  # Student Registration
  resource :registration, only: %i[new create]
  get "signup" => "registrations#new", as: :signup

  # Core Resources
  resources :products
  resources :orders
  resources :users

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
