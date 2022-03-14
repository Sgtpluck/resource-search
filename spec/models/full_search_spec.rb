require "rails_helper"

RSpec.describe FullSearch, type: :model do
  let(:query) { double("description") }
  describe "#initialize" do
    before { allow(Query::Description).to receive(:new) { query } }
    before { allow(query).to receive(:query_data) { {description: "a description"} } }

    describe "no arguments" do
      it "description key is added to terms" do
        search = FullSearch.new({})
        expect(search.terms).to eq []
      end

      it "does not add a FullQuery" do
        expect { FullSearch.new({}) }.not_to change {FullQuery.count}
      end
    end

    describe "with params" do
      it "creates a list of search terms" do
        search = FullSearch.new({"description" => "value"})

        expect(search.terms).to eq [query]
      end

      it "adds a FullQuery" do
        expect { FullSearch.new({"description" => "value"}) }.to change {FullQuery.count}
      end
    end
  end

  describe "#find_resources" do
    before { allow(ProjectResource).to receive(:search) }
    before { allow(query).to receive(:query_data) { {description: "a description"} } }

    describe "with no terms" do
      it "calls ProjectResources" do
        expect(ProjectResource).to receive(:search)

        a_search = FullSearch.new({})
        a_search.find_resources
      end
    end

    describe "with search terms" do
      let(:string) { "query string" }
      before { allow(query).to receive(:query_data) { {description: "a description"} } }

      it "calls ProjectResouce.search" do
        allow(Query::Description).to receive(:new) { query }
        allow(query).to receive(:query_string) { string }

        search = FullSearch.new("description" => "value")

        expect(ProjectResource).to receive(:search).and_return []
        expect(Guides).to receive(:search).and_return []
        search.find_resources
      end
    end
  end
end
