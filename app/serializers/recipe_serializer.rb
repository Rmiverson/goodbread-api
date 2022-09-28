class RecipeSerializer < ActiveModel::Serializer
  attributes :id, :title, :description

  has_many :textboxes
  has_many :ordered_lists
  has_many :unordered_lists
  has_many :tags
end
