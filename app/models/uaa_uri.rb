class UaaUri
  def self.string
    Rails.env.production? ?
      ProductionUri.new.string :
      DevelopmentUri.new.string
  end

  private

  def uri_params
    {
      host: host,
      path: path,
      port: port,
      query: query
    }
  end

  def query
    URI.encode_www_form({
      client_id: client_id,
      response_type: "code",
      redirect_uri: redirect_uri,
      state: state
    })
  end

  def state
    SecureRandom.hex
  end

  def path
    "/oauth/authorize"
  end
end

class UaaUri::ProductionUri < UaaUri
  def string
    uri.to_s
  end

  private

  def uri
    URI::HTTPS.build(uri_params)
  end

  def host
    "login.fr.cloud.gov"
  end

  def port
    nil
  end

  def redirect_uri
    "https://project_resource_search-stage.app.cloud.gov/auth"
  end

  def client_id
    Rails.application.credentials.uaa_client_id
  end
end

class UaaUri::DevelopmentUri < UaaUri
  def string
    uri.to_s
  end

  private

  def uri
    URI::HTTP.build(uri_params)
  end

  def host
    "localhost"
  end

  def port
    8080
  end

  def redirect_uri
    "http://localhost:3000/auth"
  end

  def client_id
    "my_client_id"
  end
end
