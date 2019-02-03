module AuthService
  class << self
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
