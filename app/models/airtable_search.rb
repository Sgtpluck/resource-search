class AirtableSearch
  attr_reader :terms

  def initialize(params)
    @terms = []

    params = {"description" => ""} if params.nil?

    params.each do |field, query|
      @terms.push "Query::#{field.titleize}".constantize.new(query)
    end
  end

  def find_resources
    ProjectResource.search(terms.map(&:query_string))
  end
end
