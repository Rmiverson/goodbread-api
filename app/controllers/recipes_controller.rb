class RecipesController < ApplicationController
        before_action :authorize_request
    def create

        permitted = recipe_params

        @recipe = Recipe.create(id: permitted[:id],

                                user_id: permitted[:user_id],

                                title: permitted[:title],

                                description: permitted[:description],

                                image: permitted[:image],

                                recipe_id: permitted[:recipe_id])



        if @recipe.valid?
                    if permitted[:component_type] === "ol" || permitted[:component_type] === "ul"
                        Recipe.update(@recipe.id, components: {title: permitted[:title], list_items: permitted[:list_items], index_order: permitted[:index_order]})
        
                    elsif permitted["component_type"] === "textbox"
                        Recipe.update(@recipe.id, components: {title: permitted[:title], text_content: permitted[:text_content], index_order: permitted[:index_order]})

                    else
                        raise Exception.new "Failed to determine recipe component type."
                    end

                #search for existing label tag if the tag is unique create a new tag

                    if tag_validator(permitted[:label])
                        new_tag = Tag.create(label: permitted[:label])
                        RecipesTag.create(recipe_id: @recipe.id, tag_id: new_tag.id) 
                    else
                        render json: {
                                    error: "Entry already exists."
                                }, status: :bad_request

                    end

            render json: RecipeSerializer.new(@recipe)
        else
            render json: {
                error: "Invalid inputs for recipes create."
            }, status: :bad_request
        end
    end

    #checks for a unique label in the database

    def tag_validator(label)

        output = true


        Recipe.all.map do |recipe|

            if !recipe.tag_list.nil?             
             list = eval(recipe.tag_list)

                if list[:label] == label; output = false
                end
            end
        end
        return output

    end



    def index
         @recipes = Recipe.all.page(params[:page]).per(15)

         if @recipes
             render json: RecipeSerializer.new(@recipes).serialized_json(meta_attributes(@recipes))
         else
             render json: {
                 error: "Failed to get recipes."
             }, status: :internal_server_error
         end
    end

    def show
        @recipe = Recipe.find(params[:id])

        if @recipe
            render json: RecipeSerializer.new(@recipe).serialized_json
        else
            render json: {
                error: "Recipe with id #{@recipe[:id]} not found."
            }, status: :not_found
        end
    end

    def update
        @recipe = Recipe.find(params[:id])

        if @recipe
            @recipe.update(params)
            @recipe.components = [@recipe.ordered_lists, @recipe.unordered_lists, @recipe.textboxes].flatten

            if !params[:components].empty?()
                @recipe.components.map do |og_component|
                    to_delete = true
                    params[:components].map do |new_component|                   
                        if og_component[:id] == new_component[:id] && og_component[:type] == new_component[:type]
                            to_delete = false
                        end
                    end
                    if to_delete == true
                        og_component.destroy
                    end
                end

                params[:components].map do |componentParameters|
                    case componentParameters["component_type"]
                    when "ol"
                        begin
                            if componentParameters["id"]
                                component = OrderedList.find(componentParameters["id"])
                                component.update(title: componentParameters["title"], list_items: componentParameters["list_items"], index_order: componentParameters["index_order"])  
                            else
                                OrderedList.create(recipe_id: @recipe[:id], title: componentParameters["title"], list_items: componentParameters["list_items"], index_order: componentParameters["index_order"])
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
                                UnorderedList.create(recipe_id: @recipe[:id], title: componentParameters["title"], list_items: componentParameters["list_items"], index_order: componentParameters["index_order"])
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
                                Textbox.create(recipe_id: @recipe[:id], title: componentParameters["title"], text_content: componentParameters["text_content"], index_order: componentParameters["index_order"])
                            end
                        rescue ActiveRecord::RecordNotUnique
                            retry
                        end
                    else
                        raise Exception.new "Failed to determine recipe component type."
                    end            
                end
            end

            if !params[:tag_list].empty?
                # deletes tags if they are missing from original db tag list
                @recipe.tags.map do |og_tag|
                    if !params[:tag_list].include?({"id" => og_tag[:id], "label" => og_tag[:label]})
                        og_tag.recipes_tags.find_by(recipe_id: @recipe[:id], tag_id: og_tag[:id]).destroy
                    end
                end  

                # creates new tags if they exist
                params[:tag_list].map do |tag|
                    find_tag = Tag.find_by(label: tag[:label])
                    if find_tag
                        find_join = RecipesTag.find_by(recipe_id: @recipe[:id], tag_id: find_tag[:id])
                        if !find_join
                            RecipesTag.create(recipe_id: @recipe[:id], tag_id: find_tag[:id])
                        end
                        find_tag
                    else
                        new_tag = Tag.create(label: tag[:label])
                        RecipesTag.create(recipe_id: @recipe[:id], tag_id: new_tag[:id]) 
                        new_tag
                    end
                    find_tag
                end
            end

            render json: RecipeSerializer.new(@recipe).serialized_json
        else
            render json: {
                error: "Could not find recipe with id of #{@recipe[:id]}."
            }, status: :not_found
        end
    end

    def destroy
        @recipe = Recipe.find(params[:id])

        if @recipe
            unless @recipe.destroy
                render json: {
                    error: "Unable to delete recipe with id of #{@recipe[:id]}"
                }, status: :internal_server_error
            end
            
            render json: {
                message: "Recipe with id of #{@recipe[:id]} successfully deleted."
            }, status: :ok
        else
            render json: {
                error: "Recipe with id of #{@recipe[:id]} not found."
            }, status: :not_found
        end
    end

    def destroyComponents
        @recipe = Recipe.find(params[:id])

        if @recipe
            if !params[:components].empty?()
                params[:components].map do |componentParameters|
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

                render json: {
                    message: "Recipe compnent(s) successfully deleted"
                }, status: :ok
            else
                render json: {
                    message: "No recipe component(s) to delete."
                }, status: :ok
            end
        else
            render json: {
                error: "Recipe with id of #{@recipe[:id]} not found."
            }, status: :not_found
        end
    end


    def recipe_params
        permitted = params.permit(
           :id,
           :user_id,
           :title,
           :description,
           :image,
           :recipe_id,
           :tag_list,
           :component_type,
           :list_items,
           :index_order,
           :text_content,
           :label,
           :tag_id)
        return permitted
    end 

end





