Rails.application.routes.draw do
  root to: "home#index"
  devise_for :users

  namespace :admin do
    resources :movies
    resources :people
    resources :genres
    resources :studios
  end

  get "/movies/:id" => "movies#show", as: 'movie'
  get "/people/buscar" => "people#buscar"
  get "/people/:id" => "people#show", as: 'person'
  get "/users/:id" => "users#show", as: 'user'

  resources :reviews, only: [:create, :update, :destroy]

  post "/process_payment", to: "posts#process_payment"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "pwa#service_worker"
  get "manifest" => "pwa#manifest"
end
