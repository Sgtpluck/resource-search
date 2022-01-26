class Query::Reuse
  attr_reader :value

  def initialize(value)
    @value = value

    QueryTerm.create(field: "Reuse", value: value)
  end

  def query_string
    "OR(" + build_string + ")"
  end

  private

  def build_string
    str = "SEARCH('Recommended', {Reusable?})"
    return str if value == "recommended"

    str += ", SEARCH('Suggested', {Reusable?})"
    return str if value == "recommended_or_suggested"

    str += ", SEARCH('Discouraged', {Reusable?})"
    str + ", SEARCH('Unreviewed', {Reusable?})"
  end
end
