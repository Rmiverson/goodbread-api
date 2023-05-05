class RecipesController < ApplicationController
  before_action :authorize_request
  
  def create
    @recipe = Recipe.create({user_id: recipe_params[:user_id], title: recipe_params[:title], description: recipe_params[:description], bodyText: recipe_params[:bodyText]})

    if @recipe.valid?
      if !recipe_params[:tag_list].empty?
        find_create_tags(recipe_params, @recipe)
      end

      render json: RecipeSerializer.new(@recipe).serialized_json
    else
      render json: {
        error: "Invalid inputs for recipes create."
      }, status: :bad_request
    end
  end

  # def index
  #   @recipes = Recipe.all.page(params[:page])

  #   if @recipes
  #     render json: RecipeSerializer.new(@recipes).serialized_json(meta_attributes(@recipes))
  #   else
  #     render json: {
  #       error: "Failed to get recipes."
  #     }, status: :internal_server_error
  #   end
  # end

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

  def search
    @user = User.find(recipe_params[:user_id])

    if @user
      if recipe_params[:query].length > 0
        @tags = @user.tags.select{ |tag| tag.label.downcase.include? recipe_params[:query].downcase }
        @recipes = @user.recipes.select{ |recipe| recipe.title.downcase.include? recipe_params[:query].downcase }
        
        @tags.each do |tag|
          @recipes.concat(tag.recipes)
        end

        if @recipes
          @uniqe_recipes = @recipes.uniq
          @sorted = sort_recipe(@uniqe_recipes, recipe_params[:sort])
          @paginated = Kaminari.paginate_array(@sorted).page(params[:page])

          render json: RecipeSerializer.new(@paginated).serialized_json(meta_attributes(@paginated))
        else
          render json: {
            message: "No Results found."
          }, status: :ok
        end
      else
          @recipes = @user.recipes.all

          if @recipes
            @sorted = sort_recipe(@recipes, recipe_params[:sort])
            @paginated = Kaminari.paginate_array(@sorted).page(params[:page])

            render json: RecipeSerializer.new(@paginated).serialized_json(meta_attributes(@paginated))
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

        find_create_tags(recipe_params, @recipe)
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

  private

  # Creates tags if they don't exist, adds them to recipe if they already exist
  def find_create_tags(recipe_params, recipe)
    recipe_params[:tag_list].map do |tag|
      @find_tag = Tag.find_by(label: tag[:label].humanize)
      
      if @find_tag
        @find_join = RecipesTag.find_by(recipe_id: recipe[:id], tag_id: @find_tag[:id])

        if !@find_join
          RecipesTag.create(recipe_id: recipe[:id], tag_id: @find_tag[:id])
        end
        
        @find_tag
      else
        @new_tag = Tag.create(user_id: recipe_params[:user_id], label: tag[:label])
        
        RecipesTag.create(recipe_id: recipe[:id], tag_id: @new_tag[:id]) 
        
        @new_tag
      end
      
      @find_tag
    end
  end

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
        :sort,
        tag_list: [
          :id,
          :label
        ]
      )
  end
end