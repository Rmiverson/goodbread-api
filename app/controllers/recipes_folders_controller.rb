class RecipesFoldersController < ApplicationController
    before_action :authorize_request
    def create
        recipes_folder = RecipesFolder.create(join_params)

        if recipes_folder.valid?
            render json: { message: "Successfully joined Recipe and Folder."}, status: 201
        else
            render json: { message: "Failed to join Recipe and Folder."}, status: 400
        end
    end

    def find_by
        recipes_folder = RecipesFolder.find_by folder_id: join_params[:folder_id], recipe_id: join_params[:recipe_id]
        
        if recipes_folder.nil?
            render json: { message: "Recipe folder join could not be found."}, status: 404
        else
            render json:recipes_folder.to_json, status: 200
        end
    end

    def destroy
        recipes_folder = RecipesFolder.find(params[:id])

        recipes_folder.destroy

        render json: { message: "Join successfully deleted."}, status: 200
    end

    private

    def join_params
        params.require(:recipes_folder).permit(:id, :folder_id, :recipe_id)
    end
end