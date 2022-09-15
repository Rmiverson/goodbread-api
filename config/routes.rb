Rails.application.routes.draw do
  resources :tags, only: [:index, :show, :create]
  resources :sub_folders, only: [:show, :create]
  resources :folders, only: [:show, :create]
  resources :users, only: [:index, :show]
  resources :recipes, only: [:index, :show, :create]
  resources :recipe_folder_joins, only: [:create]
  resources :recipe_sub_folder_joins, only: [:create]
  resources :tag_recipe_joins, only: [:create]

  post "/signup", to: "users#create"
  post "/login", to: "auth#login"
  get "/persist", to: "auth#show"

  patch '/users/:id', to: 'users#update'
  delete '/users/:id', to: 'users#destroy'

  patch '/recipes/:id', to: 'recipes#update'
  delete '/recipes/:id', to: 'recipes#destroy'
  delete '/recipes/:id/components', to: 'recipes#destroyComponents'

  patch '/folders/:id', to: 'folders#update'
  delete '/folders/:id', to: 'folders#destroy'

  patch '/sub_folders/:id', to: 'sub_folders#update'
  delete '/sub_folders/:id', to: 'sub_folders#destroy'

  get '/recipe_folder_joins', to: 'recipe_folder_joins#find_by'
  delete '/recipe_folder_joins/:id', to: 'recipe_folder_joins#destroy'

  get '/recipe_sub_folder_joins', to: 'recipe_sub_folder_joins#find_by'
  delete '/recipe_sub_folder_joins/:id', to: 'recipe_sub_folder_joins#destroy'

  patch '/tags/:id', to: 'tags#update'
  delete '/tags/:id', to: 'tags#destroy'

  patch '/tag_recipe_joins', to: 'tag_recipe_joins#find_by'
  delete '/tag_recipe_joins/:id', to: 'tag_recipe_joins#destroy'
end
