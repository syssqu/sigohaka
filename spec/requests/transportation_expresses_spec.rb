require 'rails_helper'

RSpec.describe "TransportationExpresses", :type => :request do
  describe "GET /transportation_expresses" do
    it "works! (now write some real specs)" do
      get transportation_expresses_path
      expect(response.status).to be(200)
    end
  end
end
