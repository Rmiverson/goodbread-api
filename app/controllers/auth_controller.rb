class AuthController < ApplicationController
   before_action :authorize_request, except: :login

   def login
      @user = User.find_by(username: login_params[:username])

      if @user&.authenticate(login_params[:password])
         @exp_time = Time.now + 72.hours.to_i

         @token = JsonWebToken.encode(user_id: @user.id, exp: @exp_time)

         render json: UserSerializer.new(@user).serialized_json(@token)
      else
         render json: {
            error: 'Unauthorized Login.'
         }, status: :unauthorized
      end
   end

   private

   def login_params
      params.require(:user).permit(:username, :password)
   end
 end