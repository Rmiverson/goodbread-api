class SubFolderSerializer < ActiveModel::Serializer
  attributes :id

  def initialize (sub_folder)
    @sub_folder = sub_folder
  end

  def serialized_json
    options = {
      include: {
        user: {
          only: [:id, :username]
        },
        recipe: {
          only: [:id, :title]
        }
      }
    }

    @sub_folder.to_json(options)
  end
end
