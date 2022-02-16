require "rails_helper"

RSpec.describe PangolinResource, type: :model do
  let(:fields) do
    {
      "Name" => "Name",
      "Link" => "http://example.com",
      "Description" => "This is a description"
    }
  end

  let(:resource) { PangolinResource.new(fields) }

  describe "#name" do
    it "returns the Name field" do
      expect(resource.name).to eq "Name"
    end
  end

  describe "#url" do
    it "returns the Link" do
      expect(resource.url).to eq "http://example.com"
    end
  end

  describe "#ready_for_use?" do
    it "returns Yes" do
      expect(resource.ready_for_use?).to eq "Yes"
    end
  end

  describe "#data_source" do
    it "returns Pangolin Resource" do
      expect(resource.data_source).to eq "Pangolin Resource"
    end
  end

  describe "#description" do
    it "returns the description" do
      expect(resource.description).to eq "This is a description"
    end
  end
end
