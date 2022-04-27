require "rails_helper"

RSpec.describe UaaUri, type: :model do
  describe "#self.string" do
    describe "not production env" do
      let(:uri) { double UaaUri::DevelopmentUri }
      it "creates a Development Uri and asks for the string" do
        expect(UaaUri::DevelopmentUri).to receive(:new).and_return uri
        expect(uri).to receive(:string)
        UaaUri.string
      end
    end

    describe "production env" do
      let(:uri) { double UaaUri::ProductionUri }
      it "calls the DevelopmentUri.string method" do
        allow(Rails).to receive(:env) { "production".inquiry }
        expect(UaaUri::ProductionUri).to receive(:new).and_return uri
        expect(uri).to receive(:string)
        UaaUri.string
      end
    end
  end
end

RSpec.describe UaaUri::ProductionUri, type: :model do
  let(:uri) { UaaUri::ProductionUri.new }
  before do
    allow(Rails.application).to receive_message_chain("credentials.uaa_client_id") { "my_client_id" }
    allow(SecureRandom).to receive(:hex) { 1234 }
  end

  describe "#string" do
    it "returns the correct string" do
      expect(uri.string).to eq "https://login.fr.cloud.gov/oauth/authorize?client_id=my_client_id&response_type=code&redirect_uri=https%3A%2F%2Fproject_resource_search-stage.app.cloud.gov%2Fauth&state=1234"
    end
  end
end

RSpec.describe UaaUri::DevelopmentUri, type: :model do
  let(:uri) { UaaUri::DevelopmentUri.new }
  before do
    allow(SecureRandom).to receive(:hex) { 1234 }
  end

  describe "#string" do
    it "returns the correct string" do
      expect(uri.string).to eq "http://localhost:8080/oauth/authorize?client_id=my_client_id&response_type=code&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Fauth&state=1234"
    end
  end
end
