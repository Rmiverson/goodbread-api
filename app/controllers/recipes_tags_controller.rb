class RecipesTagsController < ApplicationController
    before_action :authorize_request
    def create
        @recipe_tag = RecipesTag.create(join_params)

        if @recipe_tag
            render json: {
                message: "Successfully joined Tag and Recipe."
            }, status: :ok
        else
            render json: {
                error: "Failed to join Recipe and Tag."
            }, status: :bad_request
        end
    end

    def find_by
        @recipe_tag = RecipesTag.find_by recipe_id: join_params[:recipe_id], tag_id: join_params[:tag_id]
        
        if @recipe_tag.nil?
            render json: {
                error: "Could not find recipe tag relation."
            }, status: :not_found
        else
            render json: @recipe_tag.to_json
        end
    end

    def destroy
        @recipe_tag = RecipesTag.find(params[:id])

        if @recipe_tag
            unless @recipe_tag.destroy
                render json: {
                    error: "Could not delete recipe tag relation."
                }, status: :internal_server_error
            end

            render json: { message: "Join successfully deleted."}
        else
            render json: {
                error: "Could not find recipe tag relation."
            }, status: :not_found
        end
    end

    private

    def join_params
        params.require(:recipe_tag).permit(:id, :recipe_id, :tag_id)
    end
end
