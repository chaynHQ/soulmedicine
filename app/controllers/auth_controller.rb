class AuthController < ApplicationController
  def sign_in
    flash[:warning] = 'You are already signed in' if session[:user]
    redirect_back(fallback_location: root_path) if session[:user]
  end

  def callback
    session[:user] = AuthService.authenticate(params['firebase_token']).id
    render json: { 'user': AuthService.current_user, 'forwarding_url': session[:forwarding_url] || root_path }
  end

  def sign_out
    session[:user] = nil
    redirect_to root_path
  end
end
