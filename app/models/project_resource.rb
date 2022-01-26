Airrecord.api_key = Rails.application.credentials.airtable_key

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
end
