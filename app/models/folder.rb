class Folder < ApplicationRecord
    has_many :sub_folders, :dependent => :destroy
    has_many :recipes_folders, :dependent => :destroy
    has_many :recipes, through: :recipes_folders, :dependent => :destroy

    belongs_to :user

    validates_presence_of :user
end
