class ApplicationController < ActionController::API
  include Error::ErrorHandler
  include Sort

  def authorize_request
    headers = request.headers['Authorization']
    header = headers.split(' ').last if !header
    
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
      @exp = @decoded[:exp]

      if @exp < Time.now.to_i
        raise JWT::DecodeError.new(error: "Login Expired.")
      end

    rescue ActiveRecord::RecordNotFound => e
      render json: {
        error: e.message
      }, status: :unauthorized
        
    rescue JWT::DecodeError => e
      render json: {
        error: e.message
      }, status: :unauthorized
    end
  end

  def meta_attributes(collection, extra_meta = {})
    {
      current_page: collection.current_page,
      next_page: collection.next_page,
      prev_page: collection.prev_page,
      total_pages: collection.total_pages,
      total_count: collection.total_count
    }.merge(extra_meta)
  end
end
