class Session
  def initialize(code)
    @code = code
  end

  def email
    token[0]["email"]
  end

  private

  def token
    @token ||=
      if Rails.env.development?
        JWT.decode response_body[:access_token], nil, false
      else
        JWT.decode response_body[:access_token], nil, true, jwks: jwt_keys, algorithm: "RS256"
      end
  end

  def jwt_keys
    @jwt_keys ||= JSON.parse(
      Net::HTTP.get(URI("https://uaa.fr.cloud.gov/token_keys")),
      symbolize_names: true
    )
  end

  def uri
    @uri ||= URI(ENV["TOKEN_URI"])
  end

  def response_body
    JSON.parse(response.body, symbolize_names: true)
  end

  def response
    @response ||= Net::HTTP.post_form(uri, request_params)
  end

  def request_params
    {
      code: @code,
      grant_type: "authorization_code",
      response_type: "token",
      client_id: ENV["UAA_CLIENT_ID"] || Rails.application.credentials.uaa_client_id,
      client_secret: ENV["UAA_SECRET"] || Rails.application.credentials.uaa_client_secret,
      redirect_uri: ENV["REDIRECT_URI"]
    }
  end
end
