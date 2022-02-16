require "rails_helper"

RSpec.describe ProjectResource, type: :model do
  let(:fields) do
    {
      "Resource Name" => "Name",
      "Link" => { 
        "url" => "http://example.com"
      },
      "Reusable?" => "Recommended",
      "Description" => "This is a description"
    }
  end

  let(:resource) { ProjectResource.new(fields) }
  
  describe "#name" do
    it "returns the Resource Name field" do
      expect(resource.name).to eq "Name"
    end
  end

  describe "#url" do
    it "returns the Link url" do
      expect(resource.url).to eq "http://example.com"
    end
  end

  describe "#ready_for_use?" do
    it "returns the formatted Reusable field" do
      expect(resource.ready_for_use?).to eq "Yes"
    end

    describe "with an unknown value" do
      it "returns Unknown" do
        resource["Reusable?"] = "Weird value"
        expect(resource.ready_for_use?).to eq "Unknown"
      end
    end
  end

  describe "#data_source" do
    it "returns Project Resources" do
      expect(resource.data_source).to eq "Project Resources"
    end
  end

  describe "#description" do
    it "returns the description" do
      expect(resource.description).to eq "This is a description"
    end

    describe "with no description" do
      it "returns the Resource Name" do
        resource["Description"] = nil
        expect(resource.description).to eq resource.name
      end
    end
  end
end
