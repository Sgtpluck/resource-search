class Guides
  GUIDE_METADATA = [
    {
      affiliate: "18f-content-guide",
      access_key: Rails.application.credentials.content_access_key,
      data_source: "Content Guide"
    },
    {
      affiliate: "eng-hiring.18f.gov",
      access_key: Rails.application.credentials.eng_hiring_access_key,
      data_source: "Engineering Hiring Guide"
    },
    {
      affiliate: "ux-guide.18f.gov",
      access_key: Rails.application.credentials.ux_access_key,
      data_source: "UX Guide"
    },
    {
      affiliate: "18f-brand",
      access_key: Rails.application.credentials.brand_access_key,
      data_source: "18F Brand Guide"
    },
    {
      affiliate: "accessibility.18f.gov",
      access_key: Rails.application.credentials.accessibility_access_key,
      data_source: "Accessibility Guide"
    },
    {
      affiliate: "agile.18f.gov",
      access_key: Rails.application.credentials.agile_access_key,
      data_source: "Agile Guide"
    },
    {
      affiliate: "engineering.18f.gov",
      access_key: Rails.application.credentials.engineering_access_key,
      data_source: "Engineering Practices Guide"
    },
    {
      affiliate: "methods.18f.gov",
      access_key: Rails.application.credentials.methods_access_key,
      data_source: "Methods Guide"
    },
    {
      affiliate: "derisking-guide",
      access_key: Rails.application.credentials.derisking_access_key,
      data_source: "De-risking Guide"
    },
    {
      affiliate: "product-guide.18f.gov",
      access_key: Rails.application.credentials.product_access_key,
      data_source: "Product Guide"
    }
  ]

  def self.search(query_terms)
    return [] if query_terms[:description].nil? || query_terms[:description] == ""

    GUIDE_METADATA.map do |guide|
      Guide.new(guide, query_terms[:description]).results
    end.flatten
  end
end

class Guide
  def initialize(guide_data, query)
    @affiliate = guide_data[:affiliate]
    @access_key = guide_data[:access_key]
    @data_source = guide_data[:data_source]
    @query = query
  end

  def results
    @results ||= search_results.map { |result| GuideResult.new(result, @data_source) }
  end

  private

  def search_results
    return [] if Rails.env.test? || Rails.env.ci?

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
      query: @query,
      enable_highlighting: "false"
    })
  end
end

class GuideResult
  attr_reader :data_source, :name, :url, :description
  def initialize(result, data_source)
    @data_source = data_source
    @name = result["title"]
    @url = result["url"]
    @description = result["snippet"]
  end

  def ready_for_use?
    "N/A"
  end

  def fields
    {}
  end

  def resource_type
    "Guide page"
  end

  def file_type?
    false
  end

  def tags
    ["Public"]
  end
end
