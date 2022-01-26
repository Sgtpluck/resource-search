require "rails_helper"

RSpec.describe AirtableSearch, type: :model do
  describe "#initialize" do
    let(:query) { double("description") }
    before { allow(Query::Description).to receive(:new) { query } }

    describe "no arguments" do
      it "description key is added to terms" do
        search = AirtableSearch.new({})
        expect(search.terms).to eq []
      end
    end

    describe "with params" do
      it "creates a list of search terms" do
        search = AirtableSearch.new({"description" => "value"})

        expect(search.terms).to eq [query]
      end
    end
  end

  describe "#find_resources" do
    before { allow(ProjectResource).to receive(:search) }

    describe "with no terms" do
      it "calls ProjectResources" do
        expect(ProjectResource).to receive(:search)

        a_search = AirtableSearch.new({})
        a_search.find_resources
      end
    end

    describe "with search terms" do
      let(:string) { "query string" }

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
