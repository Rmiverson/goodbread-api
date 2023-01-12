class Recipe < ApplicationRecord
    attr_accessor :components, :tag_list


    validates :title, :description, :image,:recipe_id, :id, :user_id, presence: true
    validates :component, presence: false
    validates :tag_list, presence: false



    has_many :textboxes, :dependent => :destroy
    has_many :ordered_lists, :dependent => :destroy
    has_many :unordered_lists, :dependent => :destroy
    
    has_many :folders_recipes, :dependent => :destroy
    has_many :folders, through: :folders_recipes, :dependent => :destroy

    has_many :recipes_tags, :dependent => :destroy
    has_many :tags, through: :recipes_tags, :dependent => :destroy


    belongs_to :user

    has_one :components
    accepts_nested_attributes_for :components


    has_one :tag_list
    accepts_nested_attributes_for :tag_list

end
