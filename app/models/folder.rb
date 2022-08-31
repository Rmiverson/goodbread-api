class Folder < ApplicationRecord
    has_many :sub_folders
    has_many :recipe_folder_joins
    has_many :recipes, through: :recipe_folder_joins

    belongs_to :user

    validates_presence_of :user
end
