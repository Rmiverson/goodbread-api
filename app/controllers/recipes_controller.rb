class RecipesController < ApplicationController
    def create
        recipe = Recipe.create(recipe_params)
        
        Recipe.createComponents(recipe_params[:components])

        if recipe.valid?
            render json: RecipeSerializer.new(recipe).serialized_json
        else
            render json: { error: "Invalid inputs", status: 422}, status: 422
        end
    end

    def index
        recipe = Recipe.all
        
        render json: RecipeSerializer.new(recipe).serialized_json
    end

    def show
        recipe = Recipe.find(params[:id])
        puts recipe

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
        render json: {message: "Recipe successfully deleted"}, status: 200
    end

    private

    def recipe_params
        params.permit(:user_id, :title, :description, :components)
    end
end
