require 'rails_helper'

RSpec.describe "VacationRequests", :type => :request do
  describe "GET /vacation_requests" do
    it "works! (now write some real specs)" do
      get vacation_requests_path
      expect(response.status).to be(200)
    end
  end
end
