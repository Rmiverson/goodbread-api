class SubFoldersController < ApplicationController
    def create
        sub_folder = SubFolder.create(sub_folder_params)
        
        if folder.valid?
            render json: FolderSerializer.new(sub_folder).serialized_json
            render json: {message: "Sub_Folder created successfully"}, status: 200
        else
            render json: {message: "Failed to create sub_folder, invalid inputs"}, status: 422 
        end
    end

    def show
        sub_folder = SubFolder.find(params[:id])

        render json: SubFolderSerializer.new(sub_folder).serialized_json
    end

    def update
        sub_folder = SubFolder.find(params[:id])

        sub_folder.update(sub_folder_params)

        render json: SubFolderSerializer.new(folder).serialized_json
    end

    def destroy
        sub_folder = SubFolder.find(params[:id])

        sub_folder.destroy

        render json: {message: "Sub_Folder successfully deleted"}, status: 200
    end

    private
    
    def sub_folder_params
        params.require(:sub_folder).permit(:user_id, :title, :description)
    end
end
