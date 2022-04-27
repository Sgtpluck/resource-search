require "rails_helper"

RSpec.describe PagesHelper, type: :helper do
  describe "#resource_types" do
    it "returns an array" do
      expect(resource_types).to be_an Array
    end
  end

  describe "#uaa_login_url" do
    it "calls UaaUri builder" do
      expect(UaaUri).to receive(:string)
      uaa_login_url
    end
  end
end
