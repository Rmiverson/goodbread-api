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

    def self.createComponents(components)
        components.each do |component|
            if component.cType === ol
                OrderedList.create(component.title, component.list_items)
            elsif component.cType === "ul"
                UnorderedList.create(component.title, component.list_items)
            elsif component.cType === "textbox"
                Textbox.create(component.title, component.text_content)
            else
                raise Exception.new "Failed to determine recipe component type."
            end
        end
    end
end
