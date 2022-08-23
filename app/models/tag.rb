class Tag < ApplicationRecord
    has_many :tag_recipe_joins
    has_many :recipes, through: :tag_recipe_joins
end
