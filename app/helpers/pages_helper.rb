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
    url = ENV["UAA_LOGIN"]
    url += "?client_id=" + client_id
    url += "&response_type=code&redirect_uri=" + ENV["REDIRECT_URI"]
    url + "&state=" + state
  end

  def client_id
    ENV["UAA_CLIENT_ID"] || Rails.application.credentials.uaa_client_id
  end

  def state
    SecureRandom.hex
  end
end
