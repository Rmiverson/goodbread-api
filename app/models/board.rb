class Board < ApplicationRecord
    has_many :recipes
    has_many :sub_boards

    belongs_to :user
end
