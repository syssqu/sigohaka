require 'rails_helper'

RSpec.describe "KinmuPatterns", :type => :request do
  describe "GET /kinmu_patterns" do
    it "works! (now write some real specs)" do
      get kinmu_patterns_path
      expect(response.status).to be(200)
    end
  end
end
