class ProfilesController < ApplicationController
  before_action :require_authentication

  def show; end

  def update
    return unless current_user?

    @user = current_user
    if @user.update(profile_params)
      flash[:success] = 'Your profile has been updated'
      render json: @user.to_json
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy; end

  private

  def profile_params
    params.permit(:display_name, :email, :email_verified)
  end
end
