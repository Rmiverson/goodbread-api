class Subboard < ApplicationRecord
    has_many :recipes
    
    belongs_to :user
end
