class PangolinResource < Airrecord::Table
  self.base_key = Rails.application.credentials.pangolin_airtable_base_id
  self.table_name = "External Resources"

  def self.search(query)
    begin
      query.push("{Description} != ''")
      all(filter: "AND(#{query.join(",")})")
    rescue StandardError
      []
    end
  end

  def name
    self["Name"]
  end

  def url
    self["Link"]
  end

  def resource_type
    "Research"
  end

  def file_type?
    false
  end

  def ready_for_use?
    "Yes"
  end

  def data_source
    "Pangolin Resource"
  end

  def description
    self["Description"]
  end

  def tags
    self["Tags"]
  end
end
