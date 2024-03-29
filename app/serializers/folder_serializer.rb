class FolderSerializer < ActiveModel::Serializer
  attributes :id

  def initialize(folder)
    @folder = folder
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
    data = JSON.parse(@folder.to_json(options))
    dataWithMeta = {data: data, meta: meta}
    dataWithMeta.to_json
  end
end
