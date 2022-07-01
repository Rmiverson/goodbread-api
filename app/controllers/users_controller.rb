class UsersController < ApplicationController
    skip_before_action :authorized, only: [:create]

    # signup
    def create
       user = User.create(user_params)
       
       if user.valid?
          token = encode_token({user_id: user.id})
          render json: UserSerializer.new(user).serialized_json(token)
       else
          render json: {error: "Invalid username or password"}
       end
    end
 
    def index
       users = User.all
 
       render json: UserSerializer.new(users).serialized_json
    end
 
    def show
       user = User.find(params[:id])
 
       render json: UserSerializer.new(user).serialized_json
    end
 
    def showUserRecipess
       user = User.find(params[:id])
       recipesArr = user.recipes
       
       render json: RecipeSerializer.new(recipesArr).serialized_json
    end
 
    def update
       user = User.find(params[:id])
 
       user.update(user_params)
 
       render json: UserSerializer.new(user).serialized_json
    end
 
    def destroy
       user = User.find(params[:id])
       user.destroy
       render json: {}, status: 200
    end
 
    private
    def user_params
       params.require(:user).permit(:id, :username, :user_desc, :password)
    end
end
