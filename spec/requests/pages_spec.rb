require "rails_helper"

RSpec.describe "Pages", type: :request do
  describe "GET /home" do
    let(:search) { double FullSearch }
    before do
      allow(FullSearch).to receive(:new).and_return search
      allow(search).to receive(:find_resources).and_return []
    end

    it "returns http success" do
      get "/"
      expect(response).to have_http_status(:success)
    end
  end
end
