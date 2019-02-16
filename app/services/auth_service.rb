module AuthService
  class << self
    def initialize; end

    def authenticate(token)
      decoded_token = decode_token(token)
      # Rails.logger.info 'Authentication attempt with ' + decoded_token[0].inspect
      User.where(uid: decoded_token[0]['user_id'])
          .first_or_create
          .update(
            display_name: decoded_token[0]['name'],
            email: decoded_token[0]['email'],
            email_verified: decoded_token[0]['email_verified']
          )

      @user = User.find_by(uid: decoded_token[0]['user_id'])
    end

    def current_user
      @user
    end

    def decode_token(token)
      options = {
        algorithm: 'RS256',
        verify_aud: ENV['FIREBASE_PROJECT_ID'],
        verify_iss: "https://securetoken.google.com/#{ENV['FIREBASE_PROJECT_ID']}"
      }
      JWT.decode(token, nil, true, options) do |header|
        url = URI('https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com')
        json = JSON.parse(Net::HTTP.get(url))
        OpenSSL::X509::Certificate.new(json[header['kid']]).public_key
      end
    end
  end
end
