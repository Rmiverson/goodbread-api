class FoldersController < ApplicationController
    def create
        folder = Folder.create(folder_params)
        
        if folder.valid?
            render json: FolderSerializer.new(folder).serialized_json
        else
            render json: { message: "Failed to create folder, invalid inputs", status: 422 }, status: 422 
        end
    end

    def show
        folder = Folder.find(params[:id])

        render json: FolderSerializer.new(folder).serialized_json
    end

    def update
        folder = Folder.find(params[:id])

        folder.update(folder_params)

        render json: FolderSerializer.new(folder).serialized_json
    end

    def destroy
        folder = Folder.find(params[:id])

        folder.destroy

        render json: {message: "Folder successfully deleted"}, status: 200
    end

    private
    
    def folder_params
        params.permit(:id, :user_id, :title, :description)
    end
end
