class Tag < ApplicationRecord
    validates :label, presence: true, uniqueness: true

    has_many :recipes_tags, :dependent => :destroy
    has_many :recipes, through: :recipes_tags, :dependent => :destroy
end
