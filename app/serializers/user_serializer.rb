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
        }
      },
      except: [:password_digest, :created_at, :updated_at]
    }

    data = @user.to_json(options)
    dataToken = JSON.parse(data)
    dataToken["token"] = token
    dataToken
  end
end
