Rails.application.routes.draw do
  # start on validating crud actions on all of these routes
  resources :tags, only: [:index, :show, :create]
  resources :sub_folders, only: [:index, :show, :create]
  resources :folders, only: [:index, :show, :create]
  resources :users, only: [:index, :show, :create]
  resources :recipes, only: [:index, :show, :create]
  
  post "/signup", to: "users#create"
  post "/login", to: "auth#create"
  get "/persist", to: "auth#show"

  # users
  post '/users/:id', to: 'user#update'
  delete '/users/:id', to: 'user#destroy'

  # recipes
  post '/recipes/:id', to: 'recipe#update'
  delete '/recipes/:id', to: 'recipe#destroy'

  # folder
  post '/folder/:id', to: 'folder#update'
  delete '/folder/:id', to: 'folder#destroy'

  # sub_folders
  post '/sub_folders/:id', to: 'sub_folder#update'
  delete '/sub_folders/:id', to: 'sub_folder#destroy'

  # tags
  post '/tags/:id', to: 'tag#update'
  delete '/tags/:id', to: 'tag#destroy'
end
