class FirebaseAuthService
  ALGORITHM = 'RS256'.freeze
  CERTS_URL = 'https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com'.freeze

  def initialize(firebase_project_id)
    @firebase_project_id = firebase_project_id
  end

  def verify_and_get_token_payload(token)
    options = {
      algorithm: ALGORITHM,
      verify_aud: @firebase_project_id,
      verify_iss: "https://securetoken.google.com/#{@firebase_project_id}"
    }

    JWT.decode(token, nil, true, options, &method(:key_finder)).first
  end

  private

  def key_finder(header)
    kid = header['kid']
    json = JSON.parse(Net::HTTP.get(certs_uri))
    OpenSSL::X509::Certificate.new(json[kid]).public_key
  end

  def certs_uri
    URI(CERTS_URL)
  end
end
