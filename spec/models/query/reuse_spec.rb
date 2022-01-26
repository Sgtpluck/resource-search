require "rails_helper"

RSpec.describe Query::Reuse, type: :model do
  let(:search_term) { "recommended" }
  let(:query) { Query::Reuse.new(search_term) }

  describe "#initalize" do
    it "assigns the param to value" do
      expect(query.value).to eq search_term
    end
  end

  describe "#query_string" do
    describe "recommended" do
      it "returns an OR search query format for recomended projects" do
        query_str = "OR(SEARCH('Recommended', {Reusable?}))"

        expect(query.query_string).to eq query_str
      end
    end

    describe "recommended_or_suggested" do
      let(:search_term) { "recommended_or_suggested" }
      let(:query) { Query::Reuse.new(search_term) }

      it "returns an OR search query format for recomended and suggested projects" do
        query_str = "OR(SEARCH('Recommended', {Reusable?}), SEARCH('Suggested', {Reusable?}))"

        expect(query.query_string).to eq query_str
      end
    end

    describe "all" do
      let(:search_term) { "all" }
      let(:query) { Query::Reuse.new(search_term) }

      it "returns an OR search query format for recomended and suggested projects" do
        query_str = "OR(SEARCH('Recommended', {Reusable?}), SEARCH('Suggested', {Reusable?}), SEARCH('Discouraged', {Reusable?}), SEARCH('Unreviewed', {Reusable?}))"

        expect(query.query_string).to eq query_str
      end
    end
  end
end
