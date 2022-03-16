require "rails_helper"

RSpec.describe ProjectResource, type: :model do
  def fields(merge_terms = {})
    {
      "Resource Name" => "Name",
      "Link" => {
        "url" => "http://example.com"
      },
      "Description" => "This is a description",
      "Type of Resource" => ["Template", "Guide"],
      "File Type" => "Document",
      "Reusable?" => "Recommended",
      "Approved to share?" => "Yes",
      "Discipline" => ["Engineering", "UX"]
    }.merge(merge_terms)
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

  describe "#resource_type" do
    it "returns the Type of Resource field as a string" do
      expect(resource.resource_type).to eq "Template, Guide"
    end
  end

  describe "#file_type?" do
    it "returns true" do
      expect(resource.file_type?).to be true
    end
  end

  describe "#file_type" do
    it "returns the File Type field" do
      expect(resource.file_type).to eq "Document"
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

  describe "#tags" do
    describe "with all the fields" do
      it "returns a list of the necessary fields" do
        tag_list = ["Recommended", "Yes", "Engineering", "UX"]
        expect(resource.tags).to eq tag_list
      end

      describe "missing Reusable?" do
        let(:merge_terms) { {"Reusable?" => nil} }

        it "returns a list with the other fields" do
          resource = ProjectResource.new(fields(merge_terms))
          tag_list = ["Yes", "Engineering", "UX"]

          expect(resource.tags).to eq tag_list
        end
      end

      describe "missing Approved to share?" do
        let(:merge_terms) { {"Approved to share?" => nil} }

        it "returns a list with the other fields" do
          resource = ProjectResource.new(fields(merge_terms))
          tag_list = ["Recommended", "Engineering", "UX"]

          expect(resource.tags).to eq tag_list
        end
      end

      describe "missing Discipline" do
        let(:merge_terms) { {"Discipline" => nil} }

        it "returns a list with the other fields" do
          resource = ProjectResource.new(fields(merge_terms))
          tag_list = ["Recommended", "Yes"]

          expect(resource.tags).to eq tag_list
        end
      end

    end
  end 
end
