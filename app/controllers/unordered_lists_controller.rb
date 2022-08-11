class UnorderedListsController < ApplicationController
    def create
        ul = UnorderedList.create(unordered_list_params)

        if ul.valid?
            render json: {message: "Successfully created unordered list"}, status: 200
        else
            render json: {message: "Failed to create unordered list, invalid inputs."}, status: 422
        end
    end

    def update
        ul = UnorderedList.find(params[:id])
        render json: ul.to_json, status: 200
    end

    def destroy
        ul = UnorderedList.find(params[:id])

        ul.destroy

        render json: {message: "Successfully deleted unorderd list"}, status: 200
    end

    private
    
    def unordered_list_params
        params.require(:unordered_list).permit(:recipe_id, :title)
    end
end
