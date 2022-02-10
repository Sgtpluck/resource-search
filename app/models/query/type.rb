class Query::Type
  attr_reader :values

  def initialize(values)
    @values = values.to_hash.filter_map { |k, v| k if v == "1" }

    @values.each { |value| QueryTerm.create(field: "Type", value: value) }
  end

  def query_string
    return if values.empty?
    "OR(" + build_string + ")"
  end

  def build_string
    values
      .map { |value| "SEARCH('#{value}', {Type of Resource})" }
      .join(", ")
  end

  def query_data
    {kind: values}
  end
end
