class RecipeLikesController < ApplicationController
    def create
        like = RecipeLike.create(recipe)
        
        if like.valid?
           render json: {message: "Invalid like request"}
        else
           render json: {message: "Like successful"}
        end
     end
  
     def destroy
        like = RecipeLike.find(params[:id])
        like.destroy
        render json: {}, status: 200
     end
  
     private
  
     def recipe_like_params
        params.require(:recipe_like).permit(:user_id, :recipe_id)
     end
end
