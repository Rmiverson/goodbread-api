class UsersController < ApplicationController
    # disabled for testing
    # skip_before_action :authorized, only: [:create]

    # signup
    def create
        user = User.create(user_params)

        if user.valid?
            token = encode_token({user_id: user.id})
            render json: UserSerializer.new(user).serialized_json(token)
        else
            render json: { error: "Invalid inputs"}, status: 422
        end
    end

    def index
        users = User.all

        render json: UserSerializer.new(users).serialized_json
    end

    def show
        user = User.find(params[:id])

        render json: UserSerializer.new(user).serialized_json
    end

    def update
        user = User.find(params[:id])

        user.update(user_params)

        render json: UserSerializer.new(user).serialized_json
    end

    def destroy
        user = User.find(params[:id])
        user.destroy
        render json: {message: "User successfully deleted"}, status: 200
    end

    private
    
    def user_params
        params.permit(:id, :username, :first_name, :last_name, :email, :password, :description)
    end
end
