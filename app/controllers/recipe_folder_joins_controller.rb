class RecipeFolderJoinsController < ApplicationController
    def create
        recipe_folder_join = RecipeFolderJoin.create(join_params)

        if recipe_folder_join.valid?
            render json: { message: "Successfully joined Recipe and Folder."}, status: 201
        else
            render json: { message: "Failed to join Recipe and Folder."}, status: 400
        end
    end

    def find_by
        recipe_folder_join = RecipeFolderJoin.find_by(folder_id: join_params[:folder_id], recipe_id: join_params[:recipe_id])
        
        if recipe_folder_join.valid?
            render json:recipe_folder_join.to_json, status: 200
        else
            render json: { message: "Recipe folder join could not be found."}, status: 404
        end
    end

    def destroy
        recipe_folder_join = RecipeFolderJoin.find(params[:id])

        recipe_folder_join.destroy

        render json: { message: "Join successfully deleted."}, status: 200
    end

    private

    def join_params
        params.permit(:id, :folder_id, :recipe_id)
    end
end