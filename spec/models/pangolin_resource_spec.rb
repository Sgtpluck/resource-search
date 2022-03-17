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

  describe "#resource_type" do
    it "returns Research" do
      expect(resource.resource_type).to eq "Research"
    end
  end

  describe "#file_type?" do
    it "returns false" do
      expect(resource.file_type?).to be false
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

  describe "#tags" do
    describe "with no tags returned" do
      it "returns an empty array" do
        expect(resource.tags).to eq []
      end
    end

    describe "with a tag array" do
      it "returns the tag array" do
        tag_list = ["Privacy Act", "Other Tag"]

        expect(PangolinResource.new("Tags" => tag_list).tags).to eq tag_list
      end
    end
  end
end
