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
      let(:env) { double ActiveSupport::EnvironmentInquirer }
      it "calls new for each Guide" do
        allow(Guide).to receive(:new).and_return guide
        allow(guide).to receive(:results).and_return []
        allow(Rails).to receive(:env).and_return env
        allow(env).to receive(:test?).and_return false
        allow(env).to receive(:ci?).and_return false
        expect(Guide).to receive(:new).exactly(Guides::GUIDE_METADATA.count).times
        Guides.search({description: "alligator"})
      end
    end
  end
end

RSpec.describe GuideResult, type: :model do
  let(:result) do
    {
      "title" => "Page title",
      "url" => "http://www.example.com",
      "snippet" => "A little snippet of the page"
    }
  end

  let(:guide_result) { GuideResult.new(result, "18F Guide") }

  describe "#initialize" do
    it "sets data_source" do
      expect(guide_result.data_source).to eq "18F Guide"
    end

    it "sets description" do
      expect(guide_result.description).to eq "A little snippet of the page"
    end

    it "sets name" do
      expect(guide_result.name).to eq "Page title"
    end

    it "sets url" do
      expect(guide_result.url).to eq "http://www.example.com"
    end
  end

  describe "resource_type" do
    it "returns Guide page" do
      expect(guide_result.resource_type).to eq "Guide page"
    end
  end

  describe "file_type?" do
    it "returns false" do
      expect(guide_result.file_type?).to be false
    end
  end

  describe "tags" do
    it "returns an array with Public" do
      expect(guide_result.tags).to eq ["Public"]
    end
  end
end
