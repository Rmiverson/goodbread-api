class Recipe < ApplicationRecord
    attr_accessor :tag_list
    
    belongs_to :user

    has_many :folders_recipes, :dependent => :destroy
    has_many :folders, through: :folders_recipes, :dependent => :destroy

    has_many :recipes_tags, :dependent => :destroy
    has_many :tags, through: :recipes_tags, :dependent => :destroy

    validates_presence_of :user
end
