class SubFolder < ApplicationRecord
    has_many :recipes_sub_folders, :dependent => :destroy
    has_many :recipes, through: :recipes_sub_folders, :dependent => :destroy

    belongs_to :folder

    validates_presence_of :folder
end
