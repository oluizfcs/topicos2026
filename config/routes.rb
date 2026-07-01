Rails.application.routes.draw do
  root to: "home#index"
  devise_for :users

  namespace :admin do
    get "/people/buscar" => "people#buscar"
    get "/movies/buscar" => "movies#buscar"

    resources :movies
    resources :people
    resources :genres
    resources :studios

    delete "/images/:image_id/movie/:movie_id", to: "images#destroy_from_movie"
    delete "/images/:image_id/person/:person_id", to: "images#destroy_from_person"
    delete "/images/:image_id/studio/:studio_id", to: "images#destroy_from_studio"
  end

  get "/people/:id" => "people#show", as: "person"
  get "/movies/:id" => "movies#show", as: "movie"
  get "/studios/:id" => "studios#show", as: "studio"

  get "/profile" => "users#index", as: "profile"
  get "/buscar" => "home#buscar", as: "buscar"
  get "/premium" => "home#premium", as: "premium"
  post "/process_payment", to: "home#process_payment"

  resources :users, only: [ :show, :edit ]
  resources :reviews, only: [ :create, :update, :destroy ]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "pwa#service_worker"
  get "manifest" => "pwa#manifest"
end
