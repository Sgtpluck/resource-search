module PagesHelper
  def formatted_use
    {
      Recommended: "Yes",
      Suggested: "Needs some work",
      Discouraged: "Needs work",
      Unreviewed: "Unknown"
    }.with_indifferent_access
  end

  def resource_types
    [
      "Template",
      "Example",
      "Training",
      "Guide",
      "Case Study",
      "Report"
    ]
  end

  def uaa_login_url
    uri.to_s
  end

  private

  def uri
    is_development? ? URI::HTTP.build(uri_params) : URI::HTTPS.build(uri_params)
  end

  def uri_params
    {
      host: ENV["UAA_HOST"],
      path: ENV["UAA_PATH"],
      port: ENV["UAA_PORT"],
      query: query
    }
  end

  def query
    URI.encode_www_form({
      client_id: client_id,
      response_type: "code",
      redirect_uri: ENV["REDIRECT_URI"],
      state: state
    })
  end

  def client_id
    ENV["UAA_CLIENT_ID"] || Rails.application.credentials.uaa_client_id
  end

  def state
    SecureRandom.hex
  end

  def is_development?
    Rails.env.development?
  end
end
