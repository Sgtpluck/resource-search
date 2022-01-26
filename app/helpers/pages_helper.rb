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
end
