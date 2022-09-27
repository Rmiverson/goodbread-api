class Recipe < ApplicationRecord
    attr_accessor :components, :tag_list

    require 'json'

    has_many :textboxes, :dependent => :destroy
    has_many :ordered_lists, :dependent => :destroy
    has_many :unordered_lists, :dependent => :destroy
    has_many :tags, :dependent => :destroy
    
    has_many :recipe_folder_joins, :dependent => :destroy
    has_many :folders, through: :recipe_folder_joins, :dependent => :destroy
    
    has_many :recipe_sub_folder_joins, :dependent => :destroy
    has_many :sub_folders, through: :recipe_sub_folder_joins, :dependent => :destroy

    has_many :tag_recipe_joins, :dependent => :destroy
    has_many :tags, through: :tag_recipe_joins, :dependent => :destroy

    belongs_to :user

    validates_presence_of :user
end
