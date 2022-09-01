class SubFolder < ApplicationRecord
    has_many :recipe_sub_folder_joins, :dependent => :destroy
    has_many :recipes, through: :recipe_sub_folder_joins, :dependent => :destroy

    belongs_to :folder

    validates_presence_of :folder
end
