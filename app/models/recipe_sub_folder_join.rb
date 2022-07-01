class RecipeSubFolderJoin < ApplicationRecord
    belongs_to :recipe
    belongs_to :sub_folder
end