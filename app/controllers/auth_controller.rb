class AuthController < ApplicationController
  with_auth_session_management

  def sign_in
    if current_user # rubocop:disable Style/GuardClause
      redirect_to courses_path
    end
  end

  def callback
    token = params.require :firebase_token

    result = sign_in_with_token(
      token,
      inline_flow: ActiveRecord::Type::Boolean.new.cast(params[:inline_flow]),
      terms_accepted: params[:terms_accepted]
    )

    render json: result
  end

  def sign_out
    sign_out_current_user params[:message]

    redirect_to root_path
  end
end
