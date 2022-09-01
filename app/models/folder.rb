class Folder < ApplicationRecord
    has_many :sub_folders, :dependent => :destroy
    has_many :recipe_folder_joins, :dependent => :destroy
    has_many :recipes, through: :recipe_folder_joins, :dependent => :destroy

    belongs_to :user

    validates_presence_of :user
end
