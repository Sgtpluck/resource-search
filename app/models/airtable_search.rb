class AirtableSearch
  attr_reader :terms

  def initialize(params)
    @terms = []

    params.each do |field, query|
      @terms.push "Query::#{field.titleize}".constantize.new(query)
    end

    FullQuery.create(full_query) unless terms.empty?
  end

  def find_resources
    ProjectResource.search(terms.map(&:query_string).compact)
  end

  private

  def full_query
    terms.each_with_object({}) {|term, hash| hash.merge!(term.query_data)}
  end
end
