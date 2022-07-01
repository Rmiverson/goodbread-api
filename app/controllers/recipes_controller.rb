class RecipesController < ApplicationController
    def create
        recipe = Recipe.create(recipe_params)
        
        if recipe.valid?
           render json: RecipeSerializer.new(recipe).serialized_json
        else
           render json: {error: "Invalid inputs for new recipe"}
        end
     end
  
     def index
        recipe = Recipe.all
  
        render json: RecipeSerializer.new(recipe).serialized_json
     end
  
     def show
        recipe = Recipe.find(params[:id])
  
        render json: RecipeSerializer.new(recipe).serialized_json
     end
  
     def update
        recipe = Recipe.find(params[:id])
  
        recipe.update(recipe_params)
  
        render json: RecipeSerializer.new(recipe).serialized_json
     end
  
     def destroy
        recipe = Recipe.find(params[:id])
        recipe.destroy
        render json: {message: "Delete successful"}, status: 200
     end
  
     private
     
     def recipe_params
        params.require(:recipe).permit(:user_id, :title, :ingredients => [:name, :amount], :instructions => [], :tags => [], :contents => [:heading, :text])
     end
  
end
