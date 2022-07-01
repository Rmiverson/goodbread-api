class RecipeFolderJoin < ApplicationRecord
    belongs_to :recipe
    belongs_to :folder
end