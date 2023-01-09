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
        @tags = Tag.all

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
        params.require(:tag).permit(:id, :label)
    end
end
