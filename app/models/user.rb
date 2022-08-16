class User < ApplicationRecord
    has_many :folders
    has_many :recipes
    has_many :sub_folders, through: :folders
end
