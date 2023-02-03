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
        components: {
          only: [:id, :index_order, :sub_title, :text, :ol_items, :ul_items ]
        }
      },
      except: [:created_at, :updated_at]
    }
    data = JSON.parse(@recipe.to_json(options))
    dataWithMeta = {data: data, meta: meta}
    dataWithMeta.to_json
  end
end
