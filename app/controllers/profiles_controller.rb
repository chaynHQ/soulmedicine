class ProfilesController < ApplicationController
  before_action :require_authentication

  def show; end

  def update
    @user = current_user
    if @user.update(profile_params)
      flash[:success] = 'Your profile has been updated'
      head :no_content
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.permit(:display_name, :email)
  end
end
