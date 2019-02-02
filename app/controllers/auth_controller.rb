class AuthController < ApplicationController
  def log_in; end

  def callback
    token = params['firebase_token']
    options = {
      algorithm: 'RS256',
      verify_aud: ENV['FIREBASE_PROJECT_ID'],
      verify_iss: "https://securetoken.google.com/#{ENV['FIREBASE_PROJECT_ID']}"
    }
    decoded_token = JWT.decode(token, nil, true, options) do |header|
      url = URI('https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com')
      json = JSON.parse(Net::HTTP.get(url))
      OpenSSL::X509::Certificate.new(json[header['kid']]).public_key
    end
    @user_name = decoded_token[0]['name']
    @user_id = decoded_token[0]['user_id']
    @user_email = decoded_token[0]['email']

    user = User.where(:display_name => @user_name, :uid => @user_id, :email => @user_email).first_or_create
    if user
      session[:user] = user.id
    end

    redirect_to :controller => 'subscription', :action => 'index'
  end

  def logout
    session[:user] = nil
    redirect_to :controller => 'pages', :action => 'landing'
  end
end
