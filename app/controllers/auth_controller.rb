class AuthController < ApplicationController
  with_auth_session_management

  def sign_in
    if current_user # rubocop:disable Style/GuardClause
      flash[:warning] = 'You are already signed in'
      redirect_back fallback_location: root_path, allow_other_host: false
    end
  end

  def callback
    token = params.require(:firebase_token)

    result = sign_in_with_token token

    render json: result
  end

  def accept_policy
    return unless current_user?

    params.require(:policy_accepted)

    result = accept_user_policy

    render json: result
  end

  def sign_out
    sign_out_current_user

    redirect_to root_path
  end
end
