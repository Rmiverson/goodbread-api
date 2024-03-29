class UsersController < ApplicationController
  before_action :authorize_request, except: :create

  def create
    @user = User.create(user_params)

    if @user.valid?
      render json: UserSerializer.new(@user).serialized_json(@token) 
    else
      render json: {
        error: "Invalid inputs for signup."
      }, status: :bad_request
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

  def show
    @user = User.find(params[:id])

    if @user
      render json: UserSerializer.new(@user).serialized_json
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
          error: "Unable to update user, invalid inputs."
        }, status: :bad_request
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
          error: "Unable to delete user."
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

  # def generate_token(user_id)
  #     @exp_time = Time.now + 72.hours.to_i
  #     @token = JsonWebToken.encode(user_id: @user.id, exp: @exp_time)
  #     @token
  # end

  def find_user
    @user = User.find_by_username!(params[:username])
    
    if !@user
      render json: {
        error: "User with id #{params[:id]} not found."
      }, status: :not_found
    end

    @user
  end
  
  def user_params
    params.require(:user).permit(:id, :username, :first_name, :last_name, :email, :password, :description)
  end
end
