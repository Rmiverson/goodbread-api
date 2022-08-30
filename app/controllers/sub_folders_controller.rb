class SubFoldersController < ApplicationController
    def create
        sub_folder = SubFolder.create(sub_folder_params)

        if sub_folder.valid?
            render json: SubFolderSerializer.new(sub_folder).serialized_json
        else
            render json: {message: "Failed to create sub-folder, invalid inputs"}, status: 422 
        end
    end

    def show
        sub_folder = SubFolder.find(params[:id])

        render json: SubFolderSerializer.new(sub_folder).serialized_json
    end

    def update
        sub_folder = SubFolder.find(params[:id])

        sub_folder.update(sub_folder_params)

        render json: SubFolderSerializer.new(sub_folder).serialized_json
    end

    def destroy
        sub_folder = SubFolder.find(params[:id])

        sub_folder.destroy

        render json: {message: "Sub-Folder successfully deleted"}, status: 200
    end

    private
    
    def sub_folder_params
        params.permit(:id, :title, :folder_id, :description)
    end
end
