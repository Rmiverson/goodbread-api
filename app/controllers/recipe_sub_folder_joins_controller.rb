class RecipeSubFolderJoinsController < ApplicationController
    def create
        recipe_sub_folder_join = RecipeSubFolderJoin.create(join_params)

        if (recipe_sub_folder_join.valid?)
            render json: { message: "Successfully joined Recipe and Sub-Folder." }, status: 201
        else
            render json: { message: "Failed to join Recipe and Sub-Folder." }, status: 400
        end
    end

    def find_by
        recipe_sub_folder_join = RecipeSubFolderJoin.find_by sub_folder_id: join_params[:sub_folder_id], recipe_id: join_params[:recipe_id]

        if recipe_sub_folder_join.nil?
            render json: { message: "Recipe sub-folder join could not be found."}, status: 404           
        else
            render json:recipe_sub_folder_join.to_json, status: 200 
        end
    end

    def destroy
        recipe_sub_folder_join = RecipeSubFolderJoin.find(params[:id])

        recipe_sub_folder_join.destroy

        render json: { message: "Join successfully deleted."}, status: 200
    end

    private
    
    def join_params
        params.require(:recipe_sub_folder_join).permit(:id, :recipe_id, :sub_folder_id)
    end
end