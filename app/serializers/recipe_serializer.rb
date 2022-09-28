class RecipeSerializer < ActiveModel::Serializer
  attributes :id, :title, :description

  def initialize (recipe, meta = {})
    @recipe = recipe
  end

  def serialized_json(meta = {})
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
    data = JSON.parse(@recipe.to_json(options))
    dataWithMeta = {data: data, meta: meta}
    dataWithMeta.to_json
  end
end
