class SubFolderSerializer < ActiveModel::Serializer
  attributes :id

  def initialize (sub_folder)
    @sub_folder = sub_folder
  end

  def serialized_json
    options = {
      include: {
        recipe: {
          only: [:id, :title]
        }
      },
      except: [:created_at, :updated_at]
    }

    @sub_folder.to_json(options)
  end
end
