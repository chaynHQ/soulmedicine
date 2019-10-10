class AuthController < ApplicationController
  with_auth_session_management

  def sign_in
    redirect_to courses_path if current_user
  end

  def callback
    token = params.require :firebase_token

    result = sign_in_with_token(
      token,
      inline_flow: ActiveRecord::Type::Boolean.new.cast(params[:inline_flow]),
      terms_accepted: params[:terms_accepted]
    )

    # TODO: check if this exists

    result[:course_id] = session[:course_id]
    # TODO: Can we set the forwardingUrl here too rather than passing it back and forth?

    render json: result
  end

  def sign_out
    sign_out_current_user params[:message]

    redirect_to root_path
  end
end
