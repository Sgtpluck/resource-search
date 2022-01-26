require "rails_helper"

RSpec.describe "AirtableSearch", type: :model do
  describe "#initialize" do
    describe "no arguments" do
      it "search_terms is an empty array" do
        search = AirtableSearch.new
        expect(search.terms).to eq []
      end

      it "search_terms is an empty array" do
        search = AirtableSearch.new(nil)
        expect(search.terms).to eq []
      end
    end

    describe "with params" do
      it "creates a list of search terms" do
        query = double("description")
        allow(Query::Description).to receive(:new) { query }
        search = AirtableSearch.new({ "description" => "value" })

        expect(search.terms).to eq [query]
      end
    end
  end

  describe "#find_resources" do
    describe "with no terms" do
      it "returns an empty array" do
        search = AirtableSearch.new
        expect(search.find_resources).to eq []
      end

      it "does not call ProjectResources" do
        a_search = AirtableSearch.new
        a_search.find_resources

        expect(ProjectResource).not_to receive(:search)
      end
    end

    describe "with search terms" do
      let(:string) { "query string" }
      before { allow(ProjectResource).to receive(:search) }

      it "calls ProjectResouce.search" do
        query = double("description")
        allow(Query::Description).to receive(:new) { query }
        allow(query).to receive(:query_string) { string }

        search = AirtableSearch.new("description" => "value")

        expect(ProjectResource).to receive(:search)
        search.find_resources
      end
    end
  end
end
