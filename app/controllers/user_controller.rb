class UserController < ApplicationController
  before_action :require_authentication

  def index; end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = 'Your profile has been updated'
      render json: @user.to_json
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy; end

  private

  def user_params
    params.permit(:display_name, :email, :email_verified)
  end
end
