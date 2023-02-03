class Recipe < ApplicationRecord
    attr_accessor :component_list, :tag_list

    has_many :components, :dependent => :destroy
    
    has_many :folders_recipes, :dependent => :destroy
    has_many :folders, through: :folders_recipes, :dependent => :destroy

    has_many :recipes_tags, :dependent => :destroy
    has_many :tags, through: :recipes_tags, :dependent => :destroy

    belongs_to :user

    validates_presence_of :user
end
