class RecipesController < ApplicationController
    before_action :authorize_request
    
    def create
        @recipe = Recipe.create({user_id: recipe_params[:user_id], title: recipe_params[:title], description: recipe_params[:description]})

        if @recipe.valid?
            if !recipe_params[:component_list].empty?()
                recipe_params[:component_list].map do |component|
                    Component.create(
                        recipe_id: @recipe.id,
                        index_order: component["index_order"],
                        sub_title: component["sub_title"],
                        text: component["text"], 
                        ul_items: component["ul_items"], 
                        ol_items: component["ol_items"]
                    )
                end
            end

            if !recipe_params[:tag_list].empty?
                recipe_params[:tag_list].map do |tag|
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
                error: "Invalid inputs for recipes create."
            }, status: :bad_request
        end
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
            @recipe.update(recipe_params)

            if !recipe_params[:component_list].empty?()
                @recipe.components.map do |og_component|
                    to_delete = true

                    recipe_params[:component_list].map do |new_component|                   
                        if og_component[:id] == new_component[:id]
                            to_delete = false
                        end
                    end

                    if to_delete == true
                        og_component.destroy
                    end
                end

                recipe_params[:component_list].map do |component_params|
                    begin
                        if component_params["id"]
                            component = Component.find(component_params["id"])
                            component.update(
                                index_order: component_params["index_order"],
                                sub_title: component_params["sub_title"],
                                text: component_params["text"], 
                                ul_items: component_params["ul_items"], 
                                ol_items: component_params["ol_items"]
                            )  
                        else
                            Component.create(
                                recipe_id: @recipe.id,
                                index_order: component_params["index_order"],
                                sub_title: component_params["sub_title"],
                                text: component_params["text"], 
                                ul_items: component_params["ul_items"], 
                                ol_items: component_params["ol_items"]
                            )
                        end                     
                    rescue ActiveRecord::RecordNotUnique
                        retry
                    end          
                end
            end

            if !recipe_params[:tag_list].empty?
                # deletes tags if they are missing from original db tag list
                @recipe.tags.map do |og_tag|
                    if !recipe_params[:tag_list].include?({"id" => og_tag[:id], "label" => og_tag[:label]})
                        og_tag.recipes_tags.find_by(recipe_id: @recipe[:id], tag_id: og_tag[:id]).destroy
                    end
                end  

                # creates new tags if they exist
                recipe_params[:tag_list].map do |tag|
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
            if !recipe_params[:component_list].empty?()
                recipe_params[:omponent_list].map do |componentParameters|
                    component = component.find(componentParameters["id"])
                    component.destroy               
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

    private

    def recipe_params
        params
            .require(:recipe)
            .permit(
                :id,
                :user_id,
                :title,
                :description,
                component_list: [
                    :id,
                    :index_order,
                    :sub_title, 
                    :text, 
                    ul_items: [],
                    ol_items: []
                ],
                tag_list: [
                    :id,
                    :label
                ]
            )
            .with_defaults(component_list: [
                sub_title: nil,
                text: nil,
                ul_items: [],
                ol_items: []
            ])
    end
end