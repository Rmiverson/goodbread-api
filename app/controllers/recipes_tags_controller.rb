class RecipesTagsController < ApplicationController
    before_action :authorize_request
    def create
        recipe_tag = RecipesTag.create(join_params)

        if (recipe_tag.valid?)
            render json: { message: "Successfully joined Tag and Recipe."}, status: 201
        else
            render json: { message: "Failed to join Recipe and Tag."}, status: 400
        end
    end

    def find_by
        recipe_tag = RecipesTag.find_by recipe_id: join_params[:recipe_id], tag_id: join_params[:tag_id]
        
        if recipe_tag.nil?
            render json: { message: "Tag Recipe join could not be found."}, status: 404
        else
            render json: recipe_tag.to_json, status: 200
        end
    end

    def destroy
        recipe_tag = RecipesTag.find(params[:id])

        recipe_tag.destroy

        render json: { message: "Join successfully deleted."}, status: 200
        end

    private

    def join_params
        params.require(:recipe_tag).permit(:id, :recipe_id, :tag_id)
    end
end
