class TextboxesController < ApplicationController
    def create
        text_box = Textbox.create(text_box_params)

        if text_box.valid?
            render json: {message: "Successfully created text box."}, status: 200
        else
            render json: {message: "Failed to create text box, invalid inputs."}, status: 422
        end
    end

    def update
        text_box = TextBox.find(params[:id])
        render json: text_box.to_json, status: 200
    end

    def destroy
        text_box = TextBox.find(params[:id])

        text_box.destroy

        render json: {message: "Successfully deleted text box."}, status: 200
    end

    private
    
    def ordered_list_params
        params.require(:text_box).permit(:recipe_id, :title, :text_content)
    end
end
