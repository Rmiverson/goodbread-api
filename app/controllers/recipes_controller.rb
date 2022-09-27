class RecipesController < ApplicationController
    def create
        recipe = Recipe.create({user_id: recipe_params[:user_id], title: recipe_params[:title], description: recipe_params[:description]})

        if recipe.valid?
            if !recipe_params[:components].empty?()
                recipe_params[:components].map do |component|
                    if component["type"] === "ol"
                        OrderedList.create(recipe_id: recipe[:id], title: component["title"], list_items: component["list_items"], index_order: component["index_order"])
                    elsif component["type"] === "ul"
                        UnorderedList.create(recipe_id: recipe[:id], title: component["title"], list_items: component["list_items"], index_order: component["index_order"])
                    elsif component["type"] === "textbox"
                        Textbox.create(recipe_id: recipe[:id], title: component["title"], text_content: component["text_content"], index_order: component["index_order"])
                    else
                        raise Exception.new "Failed to determine recipe component type."
                    end
                end
            end

            render json: RecipeSerializer.new(recipe).serialized_json
        else
            render json: { error: "Invalid inputs", status: 422}, status: 422
        end
    end

    def index
        recipe = Recipe.all
        
        render json: RecipeSerializer.new(recipe).serialized_json
    end

    def show
        recipe = Recipe.find(params[:id])
        puts recipe

        render json: RecipeSerializer.new(recipe).serialized_json
    end

    def update
        recipe = Recipe.find(params[:id])
        recipe.update(recipe_params)

        if !recipe_params[:components].empty?()
            recipe_params[:components].map do |componentParameters|
                if componentParameters["type"] === "ol"
                    component = OrderedList.find(componentParameters["id"])
                    component.update(title: componentParameters["title"], list_items: componentParameters["list_items"], index_order: component["index_order"])
                elsif componentParameters["type"] === "ul"
                    component = UnorderedList.find(componentParameters["id"])
                    component.update(title: componentParameters["title"], list_items: componentParameters["list_items"], index_order: component["index_order"])
                elsif componentParameters["type"] === "textbox"
                    component = Textbox.find(componentParameters["id"])
                    component.update(title: componentParameters["title"], text_content: componentParameters["text_content"], index_order: component["index_order"])
                else
                    raise Exception.new "Failed to determine recipe component type."
                end                
            end
        end

        render json: RecipeSerializer.new(recipe).serialized_json
    end

    def destroy
        recipe = Recipe.find(params[:id])

        recipe.destroy

        render json: {message: "Recipe successfully deleted"}, status: 200
    end

    def destroyComponents
        recipe = Recipe.find(params[:id])

        if !recipe_params[:components].empty?()
            recipe_params[:components].map do |componentParameters|
                if componentParameters["type"] === "ol"
                    component = OrderedList.find(componentParameters["id"])
                    component.destroy
                elsif componentParameters["type"] === "ul"
                    component = UnorderedList.find(componentParameters["id"])
                    component.destroy
                elsif componentParameters["type"] === "textbox"
                    component = Textbox.find(componentParameters["id"])
                    component.destroy
                else
                    raise Exception.new "Failed to determine recipe component type."
                end                
            end

            render json: {message: "Recipe compnent(s) successfully deleted"}, status: 200
        else
            render json: {message: "No recipe component(s) to delete."}, status: 404
        end
    end

    private

    def recipe_params
        params.require(:recipe).permit(
            :id,
            :user_id,
            :title,
            :description,
            components: [
                :type,
                :title, 
                :text_content, 
                :index_order,
                list_items: []
            ],
            tag_list: []
        )
    end
end
