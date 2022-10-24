class Folder < ApplicationRecord
    attr_accessor :folder_ids

    # has_many :sub_folders, :dependent => :destroy
    has_many :folders_recipes, :dependent => :destroy
    # has_many :recipes, through: :folders_recipes, :dependent => :destroy

    has_many :sub_folders, foreign_key: :child_folder_id, class_name: "FolderToFolderJoin"
    has_many :sub_folder_recipes, through: :sub_folders, :dependent => :delete_all
    has_many :parent_folders, foreign_key: :parent_folder_id, class_name: "FolderToFolderJoin"
    has_many :parent_folder_recipes, through: :parent_folders, :dependent => :delete_all

    belongs_to :user

    validates_presence_of :user
end
