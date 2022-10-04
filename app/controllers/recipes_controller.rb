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
                    debugger
                    new_tag = Tag.create(label: tag[:label])
                    RecipesTag.create(recipe_id: recipe[:id], tag_id: new_tag[:id])
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

        # TODO: validata that this manages updating everything
        # TODO: work out component deletes

        recipe.components.map do |og_component|
            if !recipe_params[:components].include?(og_component)
                og_component.destroy
            end
        end

        if !recipe_params[:components].empty?()
            recipe_params[:components].map do |componentParameters|
                case componentParameters["component_type"]
                when "ol"
                    begin
                        if componentParameters["id"]
                            component = OrderedList.find(componentParameters["id"])
                            component.update(title: componentParameters["title"], list_items: componentParameters["list_items"], index_order: component["index_order"])  
                        else
                            OrderedList.create(title: componentParameters["title"], list_items: componentParameters["list_items"], index_order: component["index_order"])
                        end                     
                    rescue ActiveRecord::RecordNotUnique
                        retry
                    end
                when "ul"
                    begin
                        if componentParameters["id"]
                            component = UnorderedList.find(componentParameters["id"])
                            component.update(title: componentParameters["title"], list_items: componentParameters["list_items"], index_order: component["index_order"])                         
                        else
                            UnorderedList.create(title: componentParameters["title"], list_items: componentParameters["list_items"], index_order: component["index_order"])
                        end
                    rescue ActiveRecord::RecordNotUnique
                        retry
                    end
                when "textbox"
                    begin
                        if componentParameters["id"]
                            component = Textbox.find(componentParameters["id"])
                            component.update(title: componentParameters["title"], text_content: componentParameters["text_content"], index_order: component["index_order"])                              
                        else
                            Textbox.create(title: componentParameters["title"], text_content: componentParameters["text_content"], index_order: component["index_order"])
                        end
                    rescue ActiveRecord::RecordNotUnique
                        retry
                    end
                else
                    raise Exception.new "Failed to determine recipe component type."
                end            
            end
        end

        recipe.tags.map do |og_tag|
            # TODO: get tag deletion working
            
            # debugger
            if !recipe_params[:tag_list].include?({"id" => og_tag[:id], "label" => og_tag[:label]})
                debugger
                og_tag.recipes_tags.find_by(recipe_id: recipe[:id], tag_id: og_tag[:id]).destroy
            end
            # if recipe_params[:tag_list].each do |new_tag|
            #     if new_tag[:label] == og_tag[:label]

            # end


            # end
        end

        if !recipe_params[:tag_list].empty?
            recipe_params[:tag_list].map do |tag|
                find_tag = Tag.find(tag[:id])
                if !find_tag.valid? 
                    new_tag = Tag.create(tag[:label])
                    RecipesTag.create(recipe_id: recipe[:id], tag_id: new_tag[:id])
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
