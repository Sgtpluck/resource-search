require "rails_helper"

RSpec.describe "Pages", type: :request do
  describe "GET /home" do
    let(:search) { double AirtableSearch }
    before do
      allow(AirtableSearch).to receive(:new).and_return search
      allow(search).to receive(:find_resources).and_return []

      allow(ENV).to receive(:[]).with("UAA_HOST").and_return "example.com"
      allow(ENV).to receive(:[]).with("UAA_PATH").and_return "/path/to/uaa"
      allow(ENV).to receive(:[]).with("UAA_PORT").and_return nil
      allow(ENV).to receive(:[]).with("REDIRECT_URI").and_return "http://example.com/callback"
      allow(ENV).to receive(:[]).with("UAA_CLIENT_ID").and_return "client_id"
    end

    it "returns http success" do
      get "/"
      expect(response).to have_http_status(:success)
    end
  end
end
