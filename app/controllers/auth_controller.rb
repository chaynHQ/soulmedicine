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

    if result.is_a?(JWT::DecodeError) || result.is_a?(StandardError)
      puts "Exception Class: #{ result.class.name }"
      puts "Exception Message: #{ result.message }"
      session[:user] = nil
      flash[:alert] = 'Sorry, something went wrong! Please try again.'
      render nothing: true, status: 400
    else
      render json: result
    end
  end

  def sign_out
    sign_out_current_user params[:message]

    redirect_to root_path
  end
end
