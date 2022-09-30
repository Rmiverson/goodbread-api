class SubFolderSerializer < ActiveModel::Serializer
  attributes :id

  def initialize(sub_folder)
    @sub_folder = sub_folder
  end

  def serialized_json(meta = {})
    options = {
      include: {
        recipes: {
          only: [:id, :title]
        }
      },
      except: [:created_at, :updated_at]
    }
    data = JSON.parse(@sub_folder.to_json(options))
    dataWithMeta = {data: data, meta: meta}
    dataWithMeta.to_json
  end
end
