class RecipesTag < ApplicationRecord
    # self.table_name = 'recipes_tags'
    belongs_to :tag
    belongs_to :recipe

    validates_presence_of :tag
    validates_presence_of :recipe
end
