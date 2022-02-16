module PagesHelper
  def format_description(desc)
    # matching on the interior of markdown link notation
    # [link](http://example.com)
    # 1: "link", 2: "http://example.com"
    link_data = desc.match(/\[(.+)\]\((.+)\)/)

    if link_data
      link = "<a href=\"#{link_data[2]}\" target=\"_blank\">#{link_data[1]}</a>"
      # replacing the markdown link notation with html notation, so this
      # is gsubbing with the [] and () included
      desc = desc.gsub(/(\[.+\])(\(.+\))/, link)
    end

    simple_format(word_wrap(desc, line_width: 23)).html_safe
  end

  def resource_types
    [
      "Template",
      "Example",
      "Training",
      "Guide",
      "Case Study",
      "Report",
      "Research"
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
