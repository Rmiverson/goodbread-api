class TagRecipeJoin < ApplicationRecord
    belongs_to :tag
    belongs_to :recipe

    validates_presence_of :tag
    validates_presence_of :recipe
end
