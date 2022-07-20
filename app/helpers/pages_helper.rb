module PagesHelper
  def resource_types
    [
      "All",
      "Template",
      "Example",
      "Training",
      "Guide",
      "Case Study",
      "Report",
      "Research"
    ]
  end

  def data_sources
    [
      "All",
      "ProjectResource",
      "PangolinResource",
      "Guides"
    ]
  end

  def uaa_login_url
    UaaUri.string
  end
end
