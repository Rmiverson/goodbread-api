class RecipeSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :bodyText

  def initialize (recipe, meta = {})
    @recipe = recipe
  end

  def serialized_json(meta = {})
    options = {
      include: {
        tags: {
          only: [:id, :label, :updated_at]
        }
      },
      except: [:created_at]
    }
    data = JSON.parse(@recipe.to_json(options))
    dataWithMeta = {data: data, meta: meta}
    dataWithMeta.to_json
  end
end
