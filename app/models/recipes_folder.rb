class RecipesFolder < ApplicationRecord
    belongs_to :recipe
    belongs_to :folder

    validates_presence_of :recipe
    validates_presence_of :folder
end