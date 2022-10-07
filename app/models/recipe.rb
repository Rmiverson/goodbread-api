class Recipe < ApplicationRecord
    attr_accessor :components, :tag_list

    require 'json'

    has_many :textboxes, :dependent => :destroy
    has_many :ordered_lists, :dependent => :destroy
    has_many :unordered_lists, :dependent => :destroy
    
    has_many :folders_recipes, :dependent => :destroy
    has_many :folders, through: :folders_recipes, :dependent => :destroy
    
    has_many :recipes_sub_folders, :dependent => :destroy
    has_many :sub_folders, through: :recipes_sub_folders, :dependent => :destroy

    has_many :recipes_tags, :dependent => :destroy
    has_many :tags, through: :recipes_tags, :dependent => :destroy

    belongs_to :user

    validates_presence_of :user
end
