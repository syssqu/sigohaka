require 'spec_helper'

RSpec.describe "BusinessReports", :type => :request do
  describe "GET /business_reports" do
    it "works! (now write some real specs)" do
      get business_reports_path
      expect(response.status).to be(200)
    end
  end
end
