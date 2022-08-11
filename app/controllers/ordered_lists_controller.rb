class OrderedListsController < ApplicationController
    def create
        ol = OrderedList.create(ordered_list_params)

        if ol.valid?
            render json: {message: "Successfully created ordered list"}, status: 200
        else
            render json: {message: "Failed to create ordered list, invalid inputs."}, status: 422
        end
    end

    def update
        ol = OrderedList.find(params[:id])
        render json: ol.to_json, status: 200
    end

    def destroy
        ol = OrderedList.find(params[:id])

        ol.destroy

        render json: {message: "Successfully deleted orderd list"}, status: 200
    end

    private
    
    def ordered_list_params
        params.require(:ordered_list).permit(:recipe_id, :title)
    end
end
