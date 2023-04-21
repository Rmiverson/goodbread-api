Rails.application.routes.draw do
  resources :tags, only: [:index, :show, :create]
  resources :folders, only: [:index, :show, :create]
  resources :users, only: [:index, :show]
  resources :recipes, only: [:index, :show, :create]
  resources :folders_recipes, only: [:create]
  resources :recipe_tags, only: [:create]

  post "/signup", to: "users#create"
  post "/login", to: "auth#login"

  get '/users/:id/folders', to: 'users#show_folders'
  get '/users/:id/recipes', to: 'users#show_recipes'
  put '/users/:id', to: 'users#update'
  delete '/users/:id', to: 'users#destroy'

  post '/recipes/search', to: 'recipes#search'
  put '/recipes/:id', to: 'recipes#update'
  delete '/recipes/:id', to: 'recipes#destroy'
  delete '/recipes/:id/components', to: 'recipes#destroyComponents'

  post '/folders/search', to: 'folders#search'
  get '/folders/:id/recipes', to: 'folders#show_recipes'
  get '/folders/:id/sub_folders', to: 'folders#show_sub_folders'
  put '/folders/:id', to: 'folders#update'
  delete '/folders/:id', to: 'folders#destroy'

  get '/folders_recipes', to: 'folders_recipes#find_by'
  delete '/folders_recipes/:id', to: 'folders_recipes#destroy'

  post '/tags/search', to: 'tags#search'
  get '/tags/:id/show_recipes', to: 'tags#show_recipes'
  post '/tags/:id/recipe_search', to: 'tags#search_in_tag'
  put '/tags/:id', to: 'tags#update'
  delete '/tags/:id', to: 'tags#destroy'

  put '/tag_recipe_joins', to: 'tag_recipe_joins#find_by'
  delete '/tag_recipe_joins/:id', to: 'tag_recipe_joins#destroy'
end
