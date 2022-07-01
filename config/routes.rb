Rails.application.routes.draw do
  resources :recipe_likes
  resources :recipe_texts
  resources :recipe_unordered_lists
  resources :recipe_ordered_lists
  resources :recipe_images
  resources :tags
  resources :subboards
  resources :boards
  resources :recipes, only: [:index, :show, :create]
  resources :users, only: [:index, :show, :create]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  post '/sign_up', to: 'users#create'
  post "/login", to: "auth#create"
  get '/persist', to: 'auth#show'

  get '/userrecips/:id', to: 'users#showUserRecipes'
  post '/users/:id', to: 'users#update'
  delete '/users/:id', to: 'users#destroy'

  post '/recips/:id', to: 'recips#update'
  delete '/recips/:id', to: 'recips#destroy'

  post '/recipelikes', to: 'recipe_likes#create'
  delete '/recipelikes/:id', to: 'recipe_likes#destroy'
end
