class Folder < ApplicationRecord
    has_many :sub_folders, :dependent => :delete_all
    has_many :recipe_folder_joins, :dependent => :delete_all
    has_many :recipes, through: :recipe_folder_joins, :dependent => :delete_all

    belongs_to :user
end
