class Folder < ApplicationRecord
    attr_accessor :folder_ids

    has_many :sub_folders, :dependent => :destroy
    has_many :folders_recipes, :dependent => :destroy
    has_many :recipes, through: :folders_recipes, :dependent => :destroy

    belongs_to :user

    validates_presence_of :user
end
