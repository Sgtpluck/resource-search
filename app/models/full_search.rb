class FullSearch
  attr_reader :terms
  BASES = [
    ProjectResource,
    PangolinResource
  ]
  def initialize(params)
    @terms = []

    params.each do |field, query|
      @terms.push "Query::#{field.titleize}".constantize.new(query)
    end

    FullQuery.create(full_query) unless terms.empty?
  end

  def find_resources
    airtable_results + guide_results
  end

  private

  def airtable_results
    BASES.map do |base|
      base.search(terms.map(&:query_string).compact)
    end.flatten
  end

  def guide_results
    Guides.search(guide_search_terms)
  end

  def guide_search_terms
    terms.each_with_object({}) { |term, hash| hash.merge!(term.query_data) }
  end

  def full_query
    terms.each_with_object({}) { |term, hash| hash.merge!(term.query_data) }
  end
end
