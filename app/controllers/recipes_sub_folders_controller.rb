class RecipesSubFolderController < ApplicationController
    before_action :authorize_request
    def create
        recipes_sub_folder = RecipesSubFolder.create(join_params)

        if (recipes_sub_folder.valid?)
            render json: { message: "Successfully joined Recipe and Sub-Folder." }, status: 201
        else
            render json: { message: "Failed to join Recipe and Sub-Folder." }, status: 400
        end
    end

    def find_by
        recipes_sub_folder = RecipesSubFolder.find_by sub_folder_id: join_params[:sub_folder_id], recipe_id: join_params[:recipe_id]

        if recipes_sub_folder.nil?
            render json: { message: "Recipe sub-folder join could not be found."}, status: 404           
        else
            render json:recipes_sub_folder.to_json, status: 200 
        end
    end

    def destroy
        recipes_sub_folder = RecipesSubFolder.find(params[:id])

        recipes_sub_folder.destroy

        render json: { message: "Join successfully deleted."}, status: 200
    end

    private
    
    def join_params
        params.require(:recipes_sub_folder).permit(:id, :recipe_id, :sub_folder_id)
    end
end