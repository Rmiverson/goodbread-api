class RecipesController < ApplicationController
    before_action :authorize_request
    def create
        recipe = Recipe.create({user_id: recipe_params[:user_id], title: recipe_params[:title], description: recipe_params[:description]})

        if recipe.valid?
            if !recipe_params[:components].empty?()
                recipe_params[:components].map do |component|
                    if component["component_type"] === "ol"
                        OrderedList.create(recipe_id: recipe[:id], title: component["title"], list_items: component["list_items"], index_order: component["index_order"])
                    elsif component["component_type"] === "ul"
                        UnorderedList.create(recipe_id: recipe[:id], title: component["title"], list_items: component["list_items"], index_order: component["index_order"])
                    elsif component["component_type"] === "textbox"
                        Textbox.create(recipe_id: recipe[:id], title: component["title"], text_content: component["text_content"], index_order: component["index_order"])
                    else
                        raise Exception.new "Failed to determine recipe component type."
                    end
                end
            end

            if !recipe_params[:tag_list].empty?
                recipe_params[:tag_list].map do |tag|
                    find_tag = Tag.find_by(label: tag[:label])
                    if find_tag
                        find_join = RecipesTag.find_by(recipe_id: recipe[:id], tag_id: find_tag[:id])
                        if !find_join
                            RecipesTag.create(recipe_id: recipe[:id], tag_id: find_tag[:id])
                        end
                        find_tag
                    else
                        new_tag = Tag.create(label: tag[:label])
                        RecipesTag.create(recipe_id: recipe[:id], tag_id: new_tag[:id]) 
                        new_tag
                    end
                    find_tag
                end
            end

            render json: RecipeSerializer.new(recipe).serialized_json
        else
            render json: { error: "Invalid inputs", status: 422}, status: 422
        end
    end

    def index
        recipes = Recipes.all.page(params[:page]).per(4)

        render json: RecipeSerializer.new(recipes).serialized_json(meta_attributes(recipes))
    end

    def show
        recipe = Recipe.find(params[:id])

        render json: RecipeSerializer.new(recipe).serialized_json
    end

    def update
        recipe = Recipe.find(params[:id])
        recipe.update(recipe_params)
        recipe.components = [recipe.ordered_lists, recipe.unordered_lists, recipe.textboxes].flatten

        if !recipe_params[:components].empty?()
            recipe.components.map do |og_component|
                to_delete = true
                recipe_params[:components].map do |new_component|                   
                    if og_component[:id] == new_component[:id] && og_component[:type] == new_component[:type]
                        to_delete = false
                    end
                end
                if to_delete == true
                    og_component.destroy
                end
            end

            recipe_params[:components].map do |componentParameters|
                case componentParameters["component_type"]
                when "ol"
                    begin
                        if componentParameters["id"]
                            component = OrderedList.find(componentParameters["id"])
                            component.update(title: componentParameters["title"], list_items: componentParameters["list_items"], index_order: componentParameters["index_order"])  
                        else
                            OrderedList.create(recipe_id: recipe[:id], title: componentParameters["title"], list_items: componentParameters["list_items"], index_order: componentParameters["index_order"])
                        end                     
                    rescue ActiveRecord::RecordNotUnique
                        retry
                    end
                when "ul"
                    begin
                        if componentParameters["id"]
                            component = UnorderedList.find(componentParameters["id"])
                            component.update(title: componentParameters["title"], list_items: componentParameters["list_items"], index_order: componentParameters["index_order"])                         
                        else
                            UnorderedList.create(recipe_id: recipe[:id], title: componentParameters["title"], list_items: componentParameters["list_items"], index_order: componentParameters["index_order"])
                        end
                    rescue ActiveRecord::RecordNotUnique
                        retry
                    end
                when "textbox"
                    begin
                        if componentParameters["id"]
                            component = Textbox.find(componentParameters["id"])
                            component.update(title: componentParameters["title"], text_content: componentParameters["text_content"], index_order: componentParameters["index_order"])                              
                        else
                            Textbox.create(recipe_id: recipe[:id], title: componentParameters["title"], text_content: componentParameters["text_content"], index_order: componentParameters["index_order"])
                        end
                    rescue ActiveRecord::RecordNotUnique
                        retry
                    end
                else
                    raise Exception.new "Failed to determine recipe component type."
                end            
            end
        end

        if !recipe_params[:tag_list].empty?
            # deletes tags if they are missing from original db tag list
            recipe.tags.map do |og_tag|
                if !recipe_params[:tag_list].include?({"id" => og_tag[:id], "label" => og_tag[:label]})
                    og_tag.recipes_tags.find_by(recipe_id: recipe[:id], tag_id: og_tag[:id]).destroy
                end
            end  

            # creates new tags if they exist
            recipe_params[:tag_list].map do |tag|
                find_tag = Tag.find_by(label: tag[:label])
                if find_tag
                    find_join = RecipesTag.find_by(recipe_id: recipe[:id], tag_id: find_tag[:id])
                    if !find_join
                        RecipesTag.create(recipe_id: recipe[:id], tag_id: find_tag[:id])
                    end
                    find_tag
                else
                    new_tag = Tag.create(label: tag[:label])
                    RecipesTag.create(recipe_id: recipe[:id], tag_id: new_tag[:id]) 
                    new_tag
                end
                find_tag
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
                if componentParameters["component_type"] === "ol"
                    component = OrderedList.find(componentParameters["id"])
                    component.destroy
                elsif componentParameters["component_type"] === "ul"
                    component = UnorderedList.find(componentParameters["id"])
                    component.destroy
                elsif componentParameters["component_type"] === "textbox"
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
                :id,
                :component_type,
                :title, 
                :text_content, 
                :index_order,
                list_items: []
            ],
            tag_list: [
                :id,
                :label
            ]
        )
    end
end
