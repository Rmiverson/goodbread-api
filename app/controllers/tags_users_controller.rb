class TagsUsersController < ApplicationController
  before_action :authorize_request

  def find_by
    @user_tag = TagsUser.find_by(user_id: join_params[:user_id], tag_id: join_params[:tag_id])

    if @user_tag.nil?
      render json: {
        error: "Could not find User Tag relation."
      }, status: :not_found
    else
      render json: @user_tag.to_json
    end
  end

  private

  def join_params
    params.require(:user_tag).permit(:id, :user_id, :tag_id)
  end
end