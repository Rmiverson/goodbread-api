class UserSerializer < ActiveModel::Serializer
  attributes :id

  def initialize(user)
    @user = user
  end

  def serialized_json(token = nil)
    options = {
      include: {
        recipes: {
          only: [:id, :title]
        }, 
        folders: {
          only: [:id, :title]
        },
        # for some reason this is throwing a no method error on 'sub_folders'
        # sub_folders: {
        #   only: [:id, :title]
        # }
      },
      except: [:password_digest]
    }

    @user.to_json(options)
  end
end
