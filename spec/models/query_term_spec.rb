require "rails_helper"

RSpec.describe QueryTerm, type: :model do
  describe "#description_by_count" do
    before do
      QueryTerm.create(field: "Description", value: "e&i")
      5.times { QueryTerm.create(field: "Description", value: "a11y") }
      3.times { QueryTerm.create(field: "Description", value: "path analysis") }
    end

    it "returns grouped terms sorted by count" do
      terms = {
        "a11y" => 5,
        "path analysis" => 3,
        "e&i" => 1
      }
      expect(QueryTerm.description_by_count).to eql terms
    end
  end

  describe "#type_by_count" do
    before do
      2.times { QueryTerm.create(field: "Type", value: "Guide") }
      QueryTerm.create(field: "Type", value: "Template")
      7.times { QueryTerm.create(field: "Type", value: "Something Else") }
    end

    it "returns grouped terms sorted by count" do
      terms = {
        "Something Else" => 7,
        "Guide" => 2,
        "Template" => 1
      }
      expect(QueryTerm.type_by_count).to eql terms
    end
  end
end
