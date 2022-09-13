class TagRecipeJoinsController < ApplicationController
    def create
        tag_recipe_join = TagRecipeJoin.create(join_params)

        if (tag_recipe_join.valid?)
            render json: { message: "Successfully joined Tag and Recipe."}, status: 201
        else
            render json: { message: "Failed to join Recipe and Tag."}, status: 400
        end
    end

    def find_by
        tag_recipe_join = TagRecipeJoin.find_by recipe_id: join_params[:recipe_id], tag_id: join_params[:tag_id]
        
        if tag_recipe_join.nil?
            render json: { message: "Tag Recipe join could not be found."}, status: 404
        else
            render json: tag_recipe_join.to_json, status: 200
        end
    end

    def destroy
        tag_recipe_join = TagRecipeJoin.find(params[:id])

        tag_recipe_join.destroy

        render json: { message: "Join successfully deleted."}, status: 200
        end

    private

    def join_params
        params.require(:tag_recipe_join).permit(:id, :recipe_id, :tag_id)
    end
end
