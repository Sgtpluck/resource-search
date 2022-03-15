class ProjectResource < Airrecord::Table
  self.base_key = Rails.application.credentials.airtable_base_id
  self.table_name = "Project Resources Library"

  def self.search(query)
    begin
      all(filter: "AND(#{query.join(",")})")
    rescue StandardError
      []
    end
  end

  def name
    self["Resource Name"]
  end

  def url
    self["Link"]["url"]
  end

  def resource_type
    self["Type of Resource"]&.join(", ")
  end

  def file_type?
    true
  end

  def file_type
    self["File Type"]
  end

  def ready_for_use?
    formatting[self["Reusable?"]] || "Unknown"
  end

  def data_source
    "Project Resources"
  end

  def description
    self["Description"] || name
  end

  private

  def formatting
    {
      Recommended: "Yes",
      Suggested: "Needs some work",
      Discouraged: "Needs work",
      Unreviewed: "Unknown"
    }.with_indifferent_access
  end
end
