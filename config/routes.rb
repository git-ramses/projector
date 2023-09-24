# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'sessions#new'
  get 'sign_up', to: 'users#new'
  post 'sign_up', to: 'users#create'
  resources :users, only: %i[index show edit create update]
  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  post '/sign_out', to: 'sessions#destroy'
  get '/sign_out', to: 'sessions#destroy'
end
