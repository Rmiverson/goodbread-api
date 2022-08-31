class OrderedList < ApplicationRecord
    belongs_to :recipe

    validates_presence_of :recipe
end
