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
          only: [:id, :title, :list_items, :component_type, :index_order]
        },
        unordered_lists: {
          only: [:id, :title, :list_items, :component_type, :index_order]
        },
        textboxes: {
          only: [:id, :title, :text_content, :component_type, :index_order]
        }
      },
      except: [:created_at, :updated_at]
    }

    @recipe.to_json(options)
  end
end
