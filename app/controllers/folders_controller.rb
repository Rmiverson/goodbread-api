class FoldersController < ApplicationController
    before_action :authorize_request
    def create
        folder = Folder.create(folder_params)
        
        if folder.valid?
            render json: FolderSerializer.new(folder).serialized_json
        else
            render json: { message: "Failed to create folder, invalid inputs"}, status: 422 
        end
    end

    def index
        user_folders = User.find(params[:user_id]).folders
        
        folders = user_folders.page(params[:page]).per(4)
        
        render json: FolderSerializer.new(folders).serialized_json(meta_attributes(folders))
    end

    def show_recipes
        folder = Folder.find(params[:id])
        
        recipes = folder.recipes.page(params[:page]).per(4)

        render json: RecipeSerializer.new(recipes).serialized_json(meta_attributes(recipes))
    end

    def show_sub_folders
        folder = Folder.find(params[:id])
        
        sub_folders = folder.sub_folders.page(params[:page]).per(4)
        
        render json: SubFolderSerializer.new(sub_folders).serialized_json(meta_attributes(sub_folders))
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
        params.require(:folder).permit(:id, :user_id, :title, :description, recipe_ids: [])
    end
end
