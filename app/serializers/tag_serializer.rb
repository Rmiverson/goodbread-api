class TagSerializer < ActiveModel::Serializer
  attributes :id

  def initialize (tag, meta = {})
    @tag = tag
  end

  def serialized_json(meta = {})
    options = {
      include: {
        recipes: {
          only: [:id, :title, :updated_at]
        }
      },
      except: [:created_at]
    }
    data = JSON.parse(@tag.to_json(options))
    dataWithMeta = {data: data, meta: meta}
    dataWithMeta.to_json
  end
end
