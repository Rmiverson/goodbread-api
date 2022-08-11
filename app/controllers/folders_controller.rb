class FoldersController < ApplicationController
    def create
        folder = Folder.create(folder_params)
        
        if folder.valid?
            render json: FolderSerializer.new(folder).serialized_json
            render json: {message: "Folder created successfully"}, status: 200
        else
            render json: {message: "Failed to create folder, invalid inputs"}, status: 422 
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
        params.require(:folder).permit(:user_id, :title, :description)
    end
end
