class Tag < ApplicationRecord
    validates :label, presence: true, uniqueness: true

    belongs_to :user

    has_many :recipes_tags, :dependent => :destroy
    has_many :recipes, through: :recipes_tags, :dependent => :destroy

    has_many :tags_users, :dependent => :destroy
    has_many :users, through: :tags_users

    before_validation :uppercase

    def uppercase
        self[:label] = self[:label].humanize
    end
end
