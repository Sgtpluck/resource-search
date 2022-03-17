class QueryData
  def latest_queries
    @latest_queries ||= FullQuery.last(10).reverse
  end

  def description_data
    @description_data ||= process_count_data(
      QueryTerm.description_by_count
    )
  end

  def type_data
    @type_data ||= process_count_data(
      QueryTerm.type_by_count
    )
  end

  private

  def process_count_data(data)
    data.map { |key, value| {value: key, count: value} }
  end
end
