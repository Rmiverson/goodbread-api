class User < ApplicationRecord
    has_many :folders
    has_many :recipes
end
