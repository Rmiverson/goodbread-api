Rails.application.routes.draw do
  resources :friendships
  resources :tags
  resources :ordered_lists
  resources :unordered_lists
  resources :textboxes
  resources :sub_folders
  resources :folders
  resources :users
  resources :recipes
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
