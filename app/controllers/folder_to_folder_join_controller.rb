class FolderToFolderJoinController < ApplicationController
    before_action :authorize_request

    def create
        join = FolderToFolderJoin.create(join_params)
        
        if join.valid?
            render json: { message: "Join Successful" } status: 200            
        else
            render json: { message: "Failed to join folders" }, status: 422
        end
    end

    def destroy
        join = FolderToFolderJoin.find(join_params)

        if join.valid?
            join.destroy
        else
            render json: { message: "Failed to delete join folder" }, status: 422
        end
    end

    private

    def join_params
        params.require(:folder_to_folder_join).permit(:parent_folder_id, :child_folder_id)
    end
end