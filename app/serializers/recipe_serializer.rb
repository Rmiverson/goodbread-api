class RecipeSerializer < ActiveModel::Serializer
  attributes :id

  def initialize (recipe)
    @recipe = recipe
  end

  def serialized_json
    options = {
      include: {
        user: {
          only: [:id, :username]
        },
        recipe_likes: {
          only: [:id, :user_id]
        }
      },
      except: [:created_at, :updated_at]
    }
    
    @recipe.to_json(options)
  end
end
