class FoldersController < ApplicationController
    before_action :authorize_request

    def create
        @folder = Folder.create(folder_params)     
        
        if @folder.valid?
            render json: FolderSerializer.new(@folder).serialized_json
        else
            render json: {
                Error: "Failed to create folder, invalid inputs"
            }, status: :bad_request
        end
    end

    def show_recipes
        @folder = Folder.find(params[:id])
        @recipes = @folder.recipes.page(params[:page]).per(15)

        if @folder
            if @recipes
                render json: RecipeSerializer.new(@recipes).serialized_json(meta_attributes(@recipes))
            else
                render json: {
                    error: "Could not get recipes from folder with id of #{@folder[:id]}"
                }, status: :internal_server_error
            end
        else
            render json: {
                error: "Could not find folder with id of #{@folder[:id]}"
            }, status: :not_found
        end
    end

    def show
        @folder = Folder.find(params[:id])

        if @folder 
            render json: FolderSerializer.new(@folder).serialized_json
        else
            render json: {
                error: "Could not find folder with id of #{@folder[:id]}"
            }, status: :not_found
        end
    end

    def update
        @folder = Folder.find(params[:id])

        if @folder
            unless @folder.update(folder_params)
                render json: {
                    error: "Could not update folder with id of #{@folder[:id]}"
                }, status: :bad_request                
            end

            render json: FolderSerializer.new(@folder).serialized_json
        else
            render json: {
                error: "Could not find folder with id of #{@folder[:id]}"
            }, status: :not_found
        end
    end

    def destroy
        @folder = Folder.find(params[:id])

        if @folder
            unless @folder.destroy
                render json: {
                    error: "Could not delete folder with id of #{@folder[:id]}"
                }, status: :internal_server_error
            end

            render json: {
                message: "Folder successfully deleted"
            }, status: :ok
        else
            render json: {
                error: "Could not find folder with id of #{@folder[:id]}"
            }, status: :not_found
        end
    end

    # folders search
    def search
        @user = User.find(params[:user_id])

        if @user
            if params[:query]
                @folders = @user.folders.select{ |folder| folder.title.include? params[:query] }

                if @folders
                    @paginated = Kaminari.paginate_array(@folders).page(params[:page]).per(15)

                    render json: FolderSerializer.new(@paginated).serialized_json(meta_attributes(@paginated))
                else
                    render json: {
                        message: "No Results found"
                    }, status: :ok
                end
            else
                render json: {
                    error: "Failed to get folders."
                }, status: :internal_server_error
            end
        else
            render json: {
                error: "User with id #{params[:id]} not found."
            }, status: :not_found
        end
    end

    private
    
    def folder_params
        params
            .require(:folder)
            .permit(
                :id,
                :user_id,
                :title,
                :description,
                :query,
                recipe_ids: []
            )
    end
end
