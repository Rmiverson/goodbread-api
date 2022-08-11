class FolderSerializer < ActiveModel::Serializer
  attributes :id

  def initialize (folder)
    @folder = folder
  end

  def serialized_json
    options = {
      include: {
        user: {
          only: [:id, :username]
        },
        recipe: {
          only: [:id, :title]
        },
        sub_folder: {
          only: [:id, :title]
        }
      }
    }
  end
end
