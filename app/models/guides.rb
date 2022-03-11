class Guides
  GUIDES = [
    {
      affiliate: "18f-content-guide",
      access_key: Rails.application.credentials.content_guide_access_key
    }

  ]

  def self.search(query_terms)
    return [] if query_terms[:description].nil? || query_terms[:description] == ""

    GUIDES.map do |guide|
      Guide.new(guide, query_terms[:description]).results
    end.flatten
  end
end

class Guide
  def initialize(guide_data, query)
    @affiliate = guide_data[:affiliate]
    @access_key = guide_data[:access_key]
    @query = query
  end

  def results
    JSON.parse(Net::HTTP.get(search_uri))["web"]["results"]
  end

  def search_uri
    uri_params = {
      host: "search.usa.gov",
      path: "/api/v2/search/i14y",
      query: query
    }
    URI::HTTPS.build(uri_params)
  end

  def query
    URI.encode_www_form({
      affiliate: @affiliate,
      access_key: @access_key,
      query: @query
    })
  end
end
