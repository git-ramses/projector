# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'sessions#new'
  # users
  get 'sign_up', to: 'users#new'
  post 'sign_up', to: 'users#create'
  resources :users, only: %i[index show edit create update]
  # sessions
  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  post '/sign_out', to: 'sessions#destroy'
  get '/sign_out', to: 'sessions#destroy'
  # blogposts
  resources :blog_posts
end
