class SubFoldersController < ApplicationController
    before_action :authorize_request
    def create
        sub_folder = SubFolder.create(sub_folder_params)

        if sub_folder.valid?
            render json: SubFolderSerializer.new(sub_folder).serialized_json
        else
            render json: {message: "Failed to create sub-folder, invalid inputs"}, status: 422 
        end
    end

    def show_recipes
        sub_folder = SubFolder.find(params[:id])

        recipes = sub_folder.recipes.page(params[:page]).per(4)

        render json: RecipeSerializer.new(recipes).serialized_json(meta_attributes(recipes))
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
        params.require(:sub_folder).permit(:id, :title, :folder_id, :description, recipe_ids: [])
    end
end
