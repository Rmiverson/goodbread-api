class RecipesController < ApplicationController
    def create
        recipe = Recipe.create(recipe_params)

        if recipe.valid?
            arr = JSON.parse(recipe_params[:components])

            if !arr.empty?()
                arr.map do |component|
                    if component["type"] === "ol"
                        OrderedList.create(recipe_id: recipe[:id], title: component["title"], list_items: component["list_items"])
                    elsif component["type"] === "ul"
                        UnorderedList.create(recipe_id: recipe[:id], title: component["title"], list_items: component["list_items"])
                    elsif component["type"] === "textbox"
                        Textbox.create(recipe_id: recipe[:id], title: component["title"], text_content: component["text_content"])
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
        arr = JSON.parse(recipe_params[:components])

        if !arr.empty?()
            arr.map do |componentParameters|
                if componentParameters["type"] === "ol"
                    component = OrderedList.find(componentParameters["id"])
                    component.update(title: componentParameters["title"], list_items: componentParameters["list_items"])
                elsif componentParameters["type"] === "ul"
                    component = UnorderedList.find(componentParameters["id"])
                    component.update(title: componentParameters["title"], list_items: componentParameters["list_items"])
                elsif componentParameters["type"] === "textbox"
                    component = Textbox.find(componentParameters["id"])
                    component.update(title: componentParameters["title"], text_content: componentParameters["text_content"])
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

        arr = JSON.parse(recipe_params[:components])

        if !arr.empty?()
            arr.map do |componentParameters|
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
        params.permit(:id, :user_id, :title, :description, :components)
    end
end
