class UsersController < ApplicationController
    before_action :authorize_request, except: :create

    def create
        @user = User.create(user_params)

        if @user.valid?
            token = JsonWebToken.encode(user_id: @user.id)
            time = Time.now + 24.hours.to_i
            time_milli = time.to_f * 1000
            render json: UserSerializer.new(@user).serialized_json({token: token, exp: time_milli}) 
        else
            render json: {
                error: "Invalid inputs for signup."
            }, status: :unprocessable_entity
        end
    end

    def index
        @users = User.all

        if @users
            render json: UserSerializer.new(@users).serialized_json
        else
            render json: {
                error: "Failed to get users."
            }, status: :internal_server_error
        end
    end

    def show_folders
        @user = User.find(params[:id])

        folders = @user.folders.page(params[:page]).per(15)

        if @user
            render json: FolderSerializer.new(folders).serialized_json(meta_attributes(folders))
        else
            render json: {
                error: "User with id #{params[:id]} not found."
            }, status: :not_found
        end
    end

    def show_recipes
        @user = User.find(params[:id])

        recipes = @user.recipes.page(params[:page]).per(15)

        if @user
            render json: RecipeSerializer.new(recipes).serialized_json(meta_attributes(recipes))
        else
            render json: {
                error: "User with id #{params[:id]} not found."
            }, status: :not_found
        end
    end

    def show
        @user = User.find(params[:id])

        token = JsonWebToken.encode(user_id: @user.id)
        # redundant to have another exp time sent to the frontend, exp is handled by api 
        time = Time.now + 24.hours.to_i
        time_milli = time.to_f * 1000

        if @user
            render json: UserSerializer.new(@user).serialized_json({token: token, exp: time_milli})
        else
            render json: {
                error: "User with id #{params[:id]} not found."
            }, status: :not_found
        end
    end

    def update
        @user = User.find(params[:id])

        if @user
            unless @user.update(user_params)
                render json: {
                    errors: "Unable to update user, invalid inputs."
                }, status: :unprocessable_entity
            end

            render json: UserSerializer.new(@user).serialized_json
        else
            render json: {
                error: "User with id #{params[:id]} not found."
            }, status: :not_found
        end
    end

    def destroy
        @user = User.find(params[:id])

        if @user
            unless @user.destroy
                render json: { 
                    errors: "Unable to delete user."
                }, status: :internal_server_error
            end

            render json: {
                message: "User successfully deleted"
            }, status: :ok
        else
            render json: {
                error: "User with id #{params[:id]} not found."
            }, status: :not_found
        end
    end

    private

    def find_user
        @user = User.find_by_username!(params[:username])
        if @user
            @user
        else
            render json: {
                error: "User with id #{params[:id]} not found."
            }, status: :not_found
        end
    end
    
    def user_params
        @params = params.require(:user).permit(:id, :username, :first_name, :last_name, :email, :password, :description)

        # add custom error for bad params
    end
end
