class Recipe < ApplicationRecord
    attr_accessor :components

    require 'json'

    has_many :textboxes
    has_many :ordered_lists
    has_many :unordered_lists
    has_many :tags
    
    has_many :recipe_folder_joins
    has_many :folders, through: :recipe_folder_joins    
    
    has_many :recipe_sub_folder_joins
    has_many :sub_folders, through: :recipe_sub_folder_joins

    has_many :tag_recipe_joins
    has_many :tags, through: :tag_recipe_joins

    belongs_to :user

    validates_presence_of :user

    def self.createComponents(components, recipe_id)
        arr = JSON.parse(components)

        if !arr.empty?()
            arr.map do |component|
                if component["type"] === "ol"
                    OrderedList.create(recipe_id: recipe_id, title: component["title"], list_items: component["list_items"])
                elsif component["type"] === "ul"
                    UnorderedList.create(recipe_id: recipe_id, title: component["title"], list_items: component["list_items"])
                elsif component["type"] === "textbox"
                    Textbox.create(recipe_id: recipe_id, title: component["title"], text_content: component["text_content"])
                else
                    raise Exception.new "Failed to determine recipe component type."
                end
            end
        end
    end
end
