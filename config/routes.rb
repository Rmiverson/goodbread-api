Rails.application.routes.draw do
  # start on validating crud actions on all of these routes
  resources :tags, only: [:index, :show, :create] #validated
  resources :sub_folders, only: [:index, :show, :create]
  resources :folders, only: [:index, :show, :create]
  resources :users, only: [:index, :show, :create]
  resources :recipes, only: [:index, :show, :create]
  
  # auth and user create: signup and  login validated
  post "/signup", to: "users#create"
  post "/login", to: "auth#create"
  get "/persist", to: "auth#show"

  # users: validated
  patch '/users/:id', to: 'users#update'
  delete '/users/:id', to: 'users#destroy'

  # recipes: validated
  patch '/recipes/:id', to: 'recipes#update'
  delete '/recipes/:id', to: 'recipes#destroy'

  # folder: create validated
  patch '/folder/:id', to: 'folder#update'
  delete '/folder/:id', to: 'folder#destroy'

  # sub_folders
  patch '/sub_folders/:id', to: 'sub_folder#update'
  delete '/sub_folders/:id', to: 'sub_folder#destroy'

  # tags
  patch '/tags/:id', to: 'tag#update'
  delete '/tags/:id', to: 'tag#destroy'
end
