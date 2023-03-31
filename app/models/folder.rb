class Folder < ApplicationRecord
    has_many :folders_recipes, :dependent => :destroy
    has_many :recipes, through: :folders_recipes

    belongs_to :user

    validates_presence_of :user

    before_validation :uppercase

    def uppercase
        self[:title] = self[:title].humanize
    end
end
