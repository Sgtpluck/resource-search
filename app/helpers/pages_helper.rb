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
      {name: "Project resource library", value: "ProjectResource"},
      {name: "TTS Futures resource library", value: "PangolinResource"},
      {name: "18F guides", value: "Guides"}
    ]
  end

  def uaa_login_url
    UaaUri.string
  end
end
