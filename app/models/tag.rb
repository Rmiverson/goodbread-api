class Tag < ApplicationRecord
    has_many :tag_recipe_joins, :dependent => :destroy
    has_many :recipes, through: :tag_recipe_joins, :dependent => :destroy
end
