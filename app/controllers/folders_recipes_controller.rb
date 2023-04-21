class FoldersRecipesController < ApplicationController
  before_action :authorize_request
  
  def create
    @folders_recipe = FoldersRecipe.create(join_params)

    if @folders_recipe
      render json: {
        message: "Successfully joined Recipe and Folder."
      }, status: :ok
    else
      render json: {
        error: "Failed to join Recipe and Folder."
      }, status: :bad_request
    end
  end

  def find_by
    @folders_recipe = FoldersRecipe.find_by folder_id: join_params[:folder_id], recipe_id: join_params[:recipe_id]
    
    if @folders_recipe.nil?
      render json: {
        error: "Recipe folder join could not be found."
      }, status: :not_found
    else
      render json: @folders_recipe.to_json
    end
  end

  def destroy
    @folders_recipe = FoldersRecipe.find(params[:id])

    if @folders_recipe
      unless @folders_recipe.destroy
        render json: {
          error: "Could not delete folder recipe relation."
        }, status: :internal_server_error
      end

      render json: {
        message: "Join successfully deleted."
      }, status: :ok
    else
      render json: {
        error: "Recipe folder relation could not be found."
      }, status: :not_found
    end
  end

  private

  def join_params
    params.require(:folders_recipe).permit(:id, :folder_id, :recipe_id)
  end
end