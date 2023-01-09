class FolderToFolderJoinController < ApplicationController
    before_action :authorize_request

    def create
        @join = FolderToFolderJoin.create(join_params)
        
        if @join
            render json: {
                message: "Succesfully joined folders."
            } status: :ok
        else
            render json: {
                error: "Failed to join folders."
            }, status: :bad_request
        end
    end

    def destroy
        @join = FolderToFolderJoin.find(join_params)

        if @join
            unless @join.destroy
                render json: {
                    error: "Could not delete folders relation."
                }, status: :internal_server_error
            end

            render json: {
                message: "Successfully deleted folders relation."
            }, status: :ok
        else
            render json: {
                error: "Could not find folders relation."
            }, status: :not_found
        end
    end

    private

    def join_params
        params.require(:folder_to_folder_join).permit(:parent_folder_id, :child_folder_id)
    end
end