class AuthController < ApplicationController
    skip_before_action :authorized, only: [:create]
 
    # for login
    def create
         user = User.find_by(username: params[:username])
         
         if user && user.authenticate(params[:password])
            my_token = encode_token({user_id: user.id})
            render json: UserSerializer.new(user).serialized_json(my_token), status: 200
         else
            render json: {error: 'That user could not be found'}, status: 401
         end
    end
 
    def show
         render json: UserSerializer.new(@user).serialized_json
    end
 end