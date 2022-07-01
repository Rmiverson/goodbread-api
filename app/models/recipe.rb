class Recipe < ApplicationRecord
    has_many :textboxes
    has_many :ordered_lists
    has_many :unordered_lists
    has_many :tags
    has_many :recipe_folder_joins
    has_many :recipe_sub_folder_joins
    has_many :folders, through: :recipe_sub_folder_joins
    has_many :sub_folders, through: :recipe_sub_folder_joins

    belongs_to :user
end
