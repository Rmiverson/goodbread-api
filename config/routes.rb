Rails.application.routes.draw do
  resources :tags, only: [:index, :show, :create]
  resources :sub_folders, only: [:show, :create]
  resources :folders, only: [:index, :show, :create]
  resources :users, only: [:index, :show]
  resources :recipes, only: [:index, :show, :create]
  resources :folders_recipes, only: [:create]
  resources :recipes_sub_folders, only: [:create]
  resources :recipe_tags, only: [:create]

  post "/signup", to: "users#create"
  post "/login", to: "auth#login"

  get '/users/:id/folders', to: 'users#show_folders'
  get '/users/:id/recipes', to: 'users#show_recipes'
  patch '/users/:id', to: 'users#update'
  delete '/users/:id', to: 'users#destroy'

  patch '/recipes/:id', to: 'recipes#update'
  delete '/recipes/:id', to: 'recipes#destroy'
  delete '/recipes/:id/components', to: 'recipes#destroyComponents'

  get '/folders/:id/recipes', to: 'folders#show_recipes'
  get '/folders/:id/sub_folders', to: 'folders#show_sub_folders'
  patch '/folders/:id', to: 'folders#update'
  delete '/folders/:id', to: 'folders#destroy'

  get '/sub_folders/:id/recipes', to: 'sub_folders#show_recipes'
  patch '/sub_folders/:id', to: 'sub_folders#update'
  delete '/sub_folders/:id', to: 'sub_folders#destroy'

  get '/folders_recipes', to: 'folders_recipes#find_by'
  delete '/folders_recipes/:id', to: 'folders_recipes#destroy'

  get '/recipe_sub_folder_joins', to: 'recipe_sub_folder_joins#find_by'
  delete '/recipe_sub_folder_joins/:id', to: 'recipe_sub_folder_joins#destroy'

  patch '/tags/:id', to: 'tags#update'
  delete '/tags/:id', to: 'tags#destroy'

  patch '/tag_recipe_joins', to: 'tag_recipe_joins#find_by'
  delete '/tag_recipe_joins/:id', to: 'tag_recipe_joins#destroy'
end
