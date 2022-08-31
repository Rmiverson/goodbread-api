Rails.application.routes.draw do
  # start on validating crud actions on all of these routes
  resources :tags, only: [:index, :show, :create] #validated
  resources :sub_folders, only: [:show, :create] #validated
  resources :folders, only: [:show, :create] #validated
  resources :users, only: [:index, :show, :create] #validated
  resources :recipes, only: [:index, :show, :create] #validated
  resources :recipe_folder_joins, only: [:create] #validated
  resources :recipe_sub_folder_joins, only: [:create] #validated
  resources :tag_recipe_joins, only: [:create] #validated
  
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

  # folder: validated
  patch '/folders/:id', to: 'folders#update'
  delete '/folders/:id', to: 'folders#destroy'

  # sub_folders: validated
  patch '/sub_folders/:id', to: 'sub_folders#update'
  delete '/sub_folders/:id', to: 'sub_folders#destroy'

  # recipe_folders: validated
  get '/recipe_folder_joins', to: 'recipe_folder_joins#find_by'
  delete '/recipe_folder_joins/:id', to: 'recipe_folder_joins#destroy'

  # recipe_sub_folders: validated
  get '/recipe_sub_folder_joins', to: 'recipe_sub_folder_joins#find_by'
  delete '/recipe_sub_folder_joins/:id', to: 'recipe_sub_folder_joins#destroy'

  # tags: validated
  patch '/tags/:id', to: 'tags#update'
  delete '/tags/:id', to: 'tags#destroy'

  # tag_recipe_joins: validated
  patch '/tag_recipe_joins', to: 'tag_recipe_joins#find_by'
  delete '/tag_recipe_joins/:id', to: 'tag_recipe_joins#destroy'

  # validate recipe component creations
end
