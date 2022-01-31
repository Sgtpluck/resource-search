require "rails_helper"

RSpec.describe "pages/home.html.erb", type: :view do
  it "displays the gov banner" do
    assign(:search, {})
    assign(:results, [])

    allow(ENV).to receive(:[]).with("UAA_HOST").and_return "example.com"
    allow(ENV).to receive(:[]).with("UAA_PATH").and_return "/path/to/uaa"
    allow(ENV).to receive(:[]).with("UAA_PORT").and_return nil
    allow(ENV).to receive(:[]).with("REDIRECT_URI").and_return "http://example.com/callback"
    allow(ENV).to receive(:[]).with("UAA_CLIENT_ID").and_return "client_id"

    render template: "pages/home", layout: "layouts/application"
    expect(rendered).to match "An official website of the United States government"
  end
end
