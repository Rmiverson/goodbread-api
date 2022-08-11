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
        # left off here, try to figure out how to disply folders and their recipes and subfolders
        # also need to figure out how to create and display recipes with their inputed components
      }
    }
  end
end
