require 'rails_helper'

RSpec.describe Session, type: :model do
  describe "email" do
    let(:token_uri) { "http://example.com" }
    let(:uaa_client_id) { "client_id" }
    let(:uaa_secret) { "secret" }
    let(:redirect_uri) { "http://example.com/redirect" }
    let(:code) { "secret_code" }
    let(:request_params) do
      {
        code: code,
        grant_type: "authorization_code",
        response_type: "token",
        client_id: uaa_client_id,
        client_secret: uaa_secret,
        redirect_uri: redirect_uri
      }
    end
    let(:response) { double Net::HTTPResponse }
    let(:response_body) { JSON.generate({access_token: "1234"}) }
    let(:jwt_keys_hash) { {value: "abcde"} }

    let(:jwt_keys) { {keys: [jwt_keys_hash]} }
    let(:jwt_decoded) { [{"email" => "test@example.com"}] }

    before do
      expect(Net::HTTP).to receive(:post_form).with(URI(token_uri), request_params).and_return(response)
      expect(Net::HTTP).to receive(:get).and_return JSON.generate(jwt_keys)
      allow(ENV).to receive(:[]).with("TOKEN_URI").and_return(token_uri)
      allow(ENV).to receive(:[]).with("UAA_CLIENT_ID").and_return(uaa_client_id)
      allow(ENV).to receive(:[]).with("UAA_SECRET").and_return(uaa_secret)
      allow(ENV).to receive(:[]).with("REDIRECT_URI").and_return(redirect_uri)
      allow(response).to receive(:body).and_return(response_body)

      expect(JWT).to receive(:decode).with("1234", "abcde", true, jwt_keys_hash).and_return jwt_decoded
    end

    it "returns an email" do
      session = Session.new(code)
      expect(session.email).to eq "test@example.com"
    end
  end
end
