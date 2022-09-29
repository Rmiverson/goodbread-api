class FoldersRecipesController < ApplicationController
    before_action :authorize_request
    def create
        folders_recipe = FoldersRecipe.create(join_params)

        if folders_recipe.valid?
            render json: { message: "Successfully joined Recipe and Folder."}, status: 201
        else
            render json: { message: "Failed to join Recipe and Folder."}, status: 400
        end
    end

    def find_by
        folders_recipe = FoldersRecipe.find_by folder_id: join_params[:folder_id], recipe_id: join_params[:recipe_id]
        
        if folders_recipe.nil?
            render json: { message: "Recipe folder join could not be found."}, status: 404
        else
            render json:folders_recipe.to_json, status: 200
        end
    end

    def destroy
        folders_recipe = FoldersRecipe.find(params[:id])

        folders_recipe.destroy

        render json: { message: "Join successfully deleted."}, status: 200
    end

    private

    def join_params
        params.require(:folders_recipe).permit(:id, :folder_id, :recipe_id)
    end
end