class UserSerializer < ActiveModel::Serializer
  attributes :id

  def initialize(user)
    @user = user
  end

  def serialized_json(token = nil)
    options = {
      include: {
        recipes: {
          only: {:id, :title}
        }, 
        folders: {
          only: {:id, :title}
        },
        sub_folders: {
          only: {:id, :title}
        }
      }
    }
  end
end
