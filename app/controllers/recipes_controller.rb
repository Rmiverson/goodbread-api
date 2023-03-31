class RecipesController < ApplicationController
    before_action :authorize_request
    
    def create
        @recipe = Recipe.create({user_id: recipe_params[:user_id], title: recipe_params[:title], description: recipe_params[:description], bodyText: recipe_params[:bodyText]})

        if @recipe.valid?
            if !recipe_params[:tag_list].empty?
                recipe_params[:tag_list].map do |tag|
                    @tag_search = Tag.find_by(label: tag[:label])

                    if @tag_search
                        @find_join = RecipesTag.find_by(recipe_id: @recipe[:id], tag_id: @tag_search[:id])

                        if !@find_join
                            RecipesTag.create(recipe_id: @recipe[:id], tag_id: @tag_search[:id])
                        end

                        @tag_search
                    else
                        @new_tag = Tag.create(user_id: recipe_params[:user_id], label: tag[:label])
                        
                        RecipesTag.create(recipe_id: @recipe[:id], tag_id: new_tag[:id])
                        
                        @new_tag
                    end

                    @tag_search
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

            if !recipe_params[:tag_list].empty?
                # deletes tags if they are missing from original db tag list
                @recipe.tags.map do |og_tag|
                    if !recipe_params[:tag_list].include?({"id" => og_tag[:id], "label" => og_tag[:label]})
                        og_tag.recipes_tags.find_by(recipe_id: @recipe[:id], tag_id: og_tag[:id]).destroy
                    end
                end  

                # creates new tags if they exist
                recipe_params[:tag_list].map do |tag|
                    @find_tag = Tag.find_by(label: tag[:label])
                    
                    if @find_tag
                        @find_join = RecipesTag.find_by(recipe_id: @recipe[:id], tag_id: @find_tag[:id])

                        if !@find_join
                            RecipesTag.create(recipe_id: @recipe[:id], tag_id: @find_tag[:id])
                        end
                        
                        @find_tag
                    else
                        @new_tag = Tag.create(user_id: recipe_params[:user_id], label: tag[:label])
                        
                        RecipesTag.create(recipe_id: @recipe[:id], tag_id: @new_tag[:id]) 
                        
                        @new_tag
                    end
                    
                    @find_tag
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

    def search
        @user = User.find(params[:user_id])

        if @user
            if params[:query]
                @recipes = @user.recipes.select{ |recipe| recipe.title.include? params[:query] }
                @paginated = Kaminari.paginate_array(@recipes).page(params[:page]).per(15)

                if @recipes
                    render json: RecipeSerializer.new(@paginated).serialized_json(meta_attributes(@paginated))
                else
                    render json: {
                        message: "No Results found."
                    }, status: :ok
                end
            else
                @recipes = @user.recipes.all.page(params[:page]).per(15)

                if @recipes
                    render json: RecipeSerializer.new(@recipes).serialized_json(meta_attributes(@recipes))
                else
                    render json: {
                        error: "Failed to get recipes."
                    }, status: :internal_server_error
                end
            end
        else
            render json: {
                error: "User with id #{params[:id]} not found."
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
                :bodyText,
                :query,
                tag_list: [
                    :id,
                    :label
                ]
            )
    end
end