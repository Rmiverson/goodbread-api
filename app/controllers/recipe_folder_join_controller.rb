class RecipeFolderJoinController < ApplicationController
    def create
        recipe_folder_join = RecipeFolderJoin.create(join_params)

        if (recipe_folder_join.valid?)
            render json: { message: "Successfully joined Recipe and Folder."}, status: 201
        else
            render json: { message: "Failed to join Recipe and Folder."}, status: 400
        end
    end

    def destroy
        recipe_folder_join = RecipeFolderJoin.find(params[:id])

        recipe_folder_join.destroy

        render json: { message: "Join successfully deleted."}, status: 200
    end

    private

    def join_params
        params.permit(:id, :recipe_id, :folder_id)
    end
end