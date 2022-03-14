require "rails_helper"

RSpec.describe Guides, type: :model do
  describe "#self.search" do
    describe "with no description" do
      it "returns an empty array" do
        expect(Guides.search({description: nil})).to eq []
        expect(Guides.search({description: ""})).to eq []
      end
    end

    describe "with a description" do
      let(:guide) { double Guide }
      it "calls new for each Guide" do
        allow(Guide).to receive(:new).and_return guide
        allow(guide).to receive(:results).and_return []
        expect(Guide).to receive(:new).exactly(Guides::GUIDE_METADATA.count).times
        Guides.search({description: "alligator"})
      end
    end
  end
end
