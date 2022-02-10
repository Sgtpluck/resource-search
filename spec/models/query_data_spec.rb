require "rails_helper"

RSpec.describe QueryData, type: :model do
  let(:query_data) { QueryData.new }

  describe "#latest_queries" do
    before { allow(FullQuery).to receive(:last).and_return double FullQuery}

    it "calls last on FullQuery once" do
      expect(FullQuery).to receive(:last).once
      query_data.latest_queries
      query_data.latest_queries
    end
  end

  describe "#description_data" do
    count_data = {
      "a11y" => 4,
      "path analysis" => 3,
      "other nonsense" => 1
    }
    before { allow(QueryTerm).to receive(:description_by_count).and_return(count_data) }

    it "returns processed count data" do
      processed_data = [
        {value: "a11y", count: 4},
        {value: "path analysis", count: 3},
        {value: "other nonsense", count: 1}
      ]
      expect(query_data.description_data).to eql processed_data
    end

    it "only calls QueryTerm once" do
      expect(QueryTerm).to receive(:description_by_count).once
      query_data.description_data
      query_data.description_data
    end
  end

  describe "#type_data" do
    count_data = {
      "Template" => 8,
      "Guide" => 4,
      "Something Else" => 1
    }
    before { allow(QueryTerm).to receive(:type_by_count).and_return(count_data) }

    it "returns processed count data" do
      processed_data = [
        {value: "Template", count: 8},
        {value: "Guide", count: 4},
        {value: "Something Else", count: 1}
      ]
      expect(query_data.type_data).to eql processed_data
    end

    it "only calls QueryTerm once" do
      expect(QueryTerm).to receive(:type_by_count).once
      query_data.type_data
      query_data.type_data
    end
  end
end
