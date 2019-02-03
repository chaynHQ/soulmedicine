class AuthController < ApplicationController
  def log_in; end

  def callback
    decoded_token = AuthService.decode_token(params['firebase_token'])
    @user_name = decoded_token[0]['name']
    @user_id = decoded_token[0]['user_id']
    @user_email = decoded_token[0]['email']

    user = User.where(display_name: @user_name, uid: @user_id, email: @user_email).first_or_create
    session[:user] = user.id if user

    render :json => session[:user]
  end

  def logout
    session[:user] = nil
    redirect_to controller: 'pages', action: 'landing'
  end
end
