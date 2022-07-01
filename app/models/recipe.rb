class Recipe < ApplicationRecord
    has_many :recipe_likes, :dependent => :delete_all
    has_many :tags
    has_many :recipe_images, :dependent => :delete_all
    has_many :recipe_ordered_lists, :dependent => :delete_all
    has_many :recipe_unordered_lists, :dependent => :delete_all
    has_many :recipe_texts, :dependent => :delete_all
 
    belongs_to :user
end
