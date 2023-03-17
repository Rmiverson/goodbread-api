class TagsUser < ApplicationRecord
  belongs_to :user
  belongs_to :tag

  validates_presence_of :user
  validates_presence_of :tag
end