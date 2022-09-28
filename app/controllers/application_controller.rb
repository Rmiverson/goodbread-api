class ApplicationController < ActionController::API

   def not_found
      render json: { error: 'not_found' }, status: 404
   end

   def authorize_request
      # debugger
      headers = request.headers['Authorization']
      header = headers.split(' ').last if !header

      # debugger

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
