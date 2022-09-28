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
          only: [:id, :title, :list_items, :component_type]
        },
        unordered_lists: {
          only: [:id, :title, :list_items, :component_type]
        },
        textboxes: {
          only: [:id, :title, :text_content, :component_type]
        }
      },
      except: [:created_at, :updated_at]
    }

    @recipe.to_json(options)
  end
end
