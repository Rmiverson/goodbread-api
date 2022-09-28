require './lib/json_web_token'
class ApplicationController < ActionController::API
   def not_found
      render json: { error: 'not_found' }, status: 404
   end

   def authorize_request
      headers = request.headers['Authorization']
      header = headers.split(' ').last if !header

      # TODO: change auth to include expiry time
      # TODO: add logic to reject and logout user if token is too old

      begin
         @decoded = JsonWebToken.decode(header)
         @current_user = User.find(@decoded[:user_id])
      rescue ActiveRecord::RecordNotFound => e
         render json: { errors: e.message }, status: :unauthorized
      rescue JWT::DecodeError => e
         render json: { errors: e.message }, status: :unauthorized
      end
   end
end
