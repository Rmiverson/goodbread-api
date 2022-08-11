class Recipe < ApplicationRecord
    has_many :textboxes
    has_many :ordered_lists
    has_many :unordered_lists
    has_many :tags
    has_many :recipe_folder_joins
    has_many :recipe_sub_folder_joins
    has_many :folders, through: :recipe_sub_folder_joins
    has_many :sub_folders, through: :recipe_sub_folder_joins

    belongs_to :user

    def self.createComponents(components) {
        components.each { |component|
            case component
            when component.cType === "ol"
                OrderedList.create(component.title, component.list_items)
            when component.cType === "ul"
                UnorderedList.create(component.title, component.list_items)
            when component.cType === "textbox"
                Textbox.create(component.title, component.text_content)
            end
        }
    }
end
