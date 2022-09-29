class RecipesSubFolder < ApplicationRecord
    belongs_to :recipe
    belongs_to :sub_folder

    validates_presence_of :recipe
    validates_presence_of :sub_folder
end