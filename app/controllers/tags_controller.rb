class TagsController < ApplicationController
    before_action :authorize_request
    
    def create
        @tag = Tag.create(tag_params)

        if @tag
            render json: {
                message: "Tag successfully created."
            }, status: :ok
        else
            render json: {
                error: "Failed to create tag."
            }, status: :bad_request
        end
    end

    def index
        @user = User.find(tag_params[:user_id])
        @tags = @user.tags.all

        if @tags
            render json: @tags.to_json
        else
            render json: {
                error: "Could not get all tags."
            }, status: :internal_server_error
        end
    end

    def show
        @tag = Tag.find(params[:id])

        if @tag
            render json: @tag.to_json
        else
            render json: {
                error: "Could not find tag with id of #{@tag[:id]}."
            }, status: :not_found
        end
    end

    # shows recipes related to tags
    def show_recipes
        @user = User.find(tag_params[:user_id])
        
        if @user
            @tag = @user.tags.find(params[:id])
            
            if @tag
                @recipes = @tag.recipes.select{ |recipe| recipe.user.id === @user.id}

                if @recipes 
                    @paginated = Kaminari.paginate_array(@recipes).page(params[:page]).per(15)

                    render json: RecipeSerializer.new(@paginated).serialized_json(meta_attributes(@paginated))
                else
                    render json: {
                        error: "No recipes found by user id #{tag_params[:id]} in tag of id #{params[:id]}"
                    }
                end
            else
                render json: {
                    error: "Could not find tag with id of #{params[:id]} associated with user of #{tag_params[:user_id]}"
                }
            end
        else
            render json: {
                error: "Could not find user with id of #{tag_params[:user_id]}"
            }, status: :not_found
        end
    end

    # search Tags
    def search
        @user = User.find(tag_params[:user_id])
        
        if @user
            if tag_params[:query].length > 0
                @tags = @user.tags.select{ |tag| tag.label.downcase.include? tag_params[:query].downcase}
                
                if @tags
                    @paginated = Kaminari.paginate_array(@tags).page(params[:page]).per(15)

                    render json: TagSerializer.new(@paginated).serialized_json(meta_attributes(@paginated))
                else
                    render json: {
                        message: "No Results found."
                    }, status: :ok
                end
            else
                @tags = @user.tags.all.page(params[:page]).per(15)

                if @tags
                    render json: TagSerializer.new(@tags).serialized_json(meta_attributes(@tags))
                else
                    render json: {
                        error: "Failed to get Tags."
                    }, status: :internal_server_error                    
                end
            end
        else
            render json: {
                error: "User with id #{params[:id]} not found."
            }, status: :not_found
        end
    end

    # searches recipes associated to specific tag
    def search_in_tag {
        @user = User.find(tag_params[:user_id])
        
        if @user
            @tag = @user.tags.find(params[:id])
            
            if @tag
                @recipes = @tag.recipes.select{ |recipe| recipe.user.id === @user.id}
                
                if @recipes 
                    if tag_params[:query].length > 0
                        @queried_recipes = @recipes.select{ |recipe| recipe.title.downcase.include? tag_params[:query].downcase }

                        if @queried_recipes
                            @paginated = Kaminari.paginate_array(@queried_recipes).page(params[:page]).per(15)

                            render json: RecipeSerializer.new(@paginated).serialized_json(meta_attributes(@paginated))
                        else
                            render json: {
                                message: "No Results found."
                            }, status: :ok
                        end
                    else
                        @paginated = Kaminari.paginate_array(@recipes).page(params[:page]).per(15)
    
                        render json: RecipeSerializer.new(@paginated).serialized_json(meta_attributes(@paginated))
                    end
                else
                    render json: {
                        error: "No recipes found by user id #{tag_params[:id]} in tag of id #{params[:id]}"
                    }
                end 
            else
                render json: {
                    error: "Could not find tag with id of #{params[:id]} associated with user of #{tag_params[:user_id]}"
                }
            end
        else
            render json: {
                error: "Could not find user with id of #{tag_params[:user_id]}"
            }, status: :not_found
        end
    }

    def update
        @tag = Tag.find(params[:id])

        if @tag
            unless @tag.update(tag_params)
                render json: {
                    error: "Could not update tag with id of #{@tag[:id]}."
                }, status: :bad_request
            end

            render json: @tag.to_json
        else
            render json: {
                error: "Could not find tag with id of #{@tag[:id]}."
            }, status: :not_found
        end
    end

    def destroy
        @tag = Tag.find(params[:id])
        
        if @tag
            unless @tag.destroy
                render json: {
                    error: "Could not delete tag with id of #{@tag[:id]}."
                }
            end

            render json: {
                message: "Tag successfully deleted."
            }, status: :ok
        else
            render json: {
                error: "Could not find tag with id of #{@tag[:id]}."
            }, status: :not_found
        end
    end

    private

    def tag_params
        params.require(:tag).permit(:id, :user_id, :label, :page, :query)
    end
end
