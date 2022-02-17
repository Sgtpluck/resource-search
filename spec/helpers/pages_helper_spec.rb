require "rails_helper"

RSpec.describe PagesHelper, type: :helper do
  describe "#format_description" do
    describe "with no links" do
      describe "longer than a 23 character line width" do
        it "returns the string formatted into html with a line break" do
          desc = "This is a string that needs to be broken"
          formatted = "<p>This is a string that\n<br />needs to be broken</p>"

          expect(format_description(desc)).to eq formatted
        end

        describe "that has a markdown link" do
          it "replaces the markdown link with an anchor tag" do 
            desc = "This is a string with a [link](http:example.com) that needs to be broken"
            formatted = "<p>This is a string with a\n<br /><a href=\"http:example.com\">link</a>\n<br />that needs to be broken</p>"

            expect(format_description(desc)).to eq formatted
          end
        end

        describe "that has markdown link characters" do
          it "does not replace them with an anchor tag" do
            desc = "A [string] that does have a link (http:example.com)"
            formatted = "<p>A [string] that does\n<br />have a link\n<br />(http:example.com)</p>"

            expect(format_description(desc)).to eq formatted
          end
        end
      end
    end
  end

  describe "#resource_types" do
    it "returns an array" do
      expect(resource_types).to be_an Array
    end
  end

  describe "#uaa_login_url" do
    let(:host) { "example.com" }
    let(:path) { "/oauth" }
    let(:redirect) { "http://example.com/redirect" }
    before do
      allow(ENV).to receive(:[]).with("UAA_HOST").and_return(host)
      allow(ENV).to receive(:[]).with("UAA_PATH").and_return(path)
      allow(ENV).to receive(:[]).with("UAA_PORT").and_return(nil)
      allow(ENV).to receive(:[]).with("REDIRECT_URI").and_return(redirect)
    end

    describe "dev" do
      let(:env) { double ActiveSupport::EnvironmentInquirer }
      before do
        allow(Rails).to receive(:env).and_return env
        allow(env).to receive(:development?).and_return true
        allow(ENV).to receive(:[]).with("UAA_CLIENT_ID").and_return "client_id"
        allow(URI).to receive(:encode_www_form).and_return "querystring"
      end

      it "calls the HTTP builder" do
        params = {
          host: host,
          path: path,
          port: nil,
          query: "querystring"
        }
        expect(URI::HTTP).to receive(:build).with params
        uaa_login_url
      end
    end

    describe "production" do
      let(:application) { double ProjectResourceSearch::Application }
      let(:credentials) { double ActiveSupport::EncryptedConfiguration }
      before do
        allow(ENV).to receive(:[]).with("UAA_CLIENT_ID").and_return nil
        allow(URI).to receive(:encode_www_form).and_return "querystring"
      end

      it "calls into the credentials and the HTTPS builder" do
        expect(Rails).to receive(:application).and_return application
        expect(application).to receive(:credentials).and_return credentials
        expect(credentials).to receive(:uaa_client_id).and_return "secret"

        params = {
          host: host,
          path: path,
          port: nil,
          query: "querystring"
        }

        expect(URI::HTTPS).to receive(:build).with params
        uaa_login_url
      end
    end
  end
end
