class AuthController < ApplicationController
  with_auth_session_management

  def sign_in
    session.delete(:last_course_id)
    if params.key?(:last_course_id)
      session[:last_course_id] = params[:last_course_id]
    elsif params.key?(:course_id)
      session[:last_course_id] = params[:course_id]
      session[:forwarding_url] = course_path(params[:course_id])
    end

    redirect_to courses_path if current_user
  end

  def callback
    token = params.require :firebase_token

    result = sign_in_with_token(
      token,
      terms_accepted: params[:terms_accepted]
    )

    render json: result
  rescue StandardError => e
    Rollbar.critical('Server Login Error', e)
    session[:user] = nil
    render json: { name: e }, status: :unprocessable_entity
  end

  def sign_out
    sign_out_current_user params[:message]

    redirect_to root_path
  end
end
