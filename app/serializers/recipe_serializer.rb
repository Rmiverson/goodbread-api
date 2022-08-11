class RecipeSerializer < ActiveModel::Serializer
  attributes :id

  def initialize (recipe)
    @recipe = recipe
  end

  def serialized_json
    options = {
      include: {
        tags: {
          only: [:id, :label]
        },
        ordered_lists: {
          only: [:id, :title, :list_items]
        },
        unordered_lists: {
          only: [:id, :title, :list_items,]
        },
        textboxes: {
          only: [:id, :title, :text_content]
        }
      } 
    }
  end
end
