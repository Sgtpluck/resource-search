require "rails_helper"

RSpec.describe Query::Description, type: :model do
  let(:search_term) { "search value" }
  before { allow(QueryTerm).to receive(:create) }
  let(:query) { Query::Description.new(search_term) }

  describe "#initalize" do
    it "assigns the param to value" do
      expect(query.value).to eq search_term
    end

    it "creates a new QueryTerm object" do
      expect(QueryTerm).to receive(:create)

      query.value
    end
  end

  describe "#query_string" do
    it "returns text search query format" do
      query_str = "SEARCH('search value', {Description})"

      expect(query.query_string).to eq query_str
    end
  end
end
