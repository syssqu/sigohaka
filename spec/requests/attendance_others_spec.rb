require 'rails_helper'

RSpec.describe "AttendanceOthers", :type => :request do
  describe "GET /attendance_others" do
    it "works! (now write some real specs)" do
      get attendance_others_path
      expect(response.status).to be(200)
    end
  end
end
