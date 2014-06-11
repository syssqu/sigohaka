require "rails_helper"

RSpec.describe AttendanceOthersController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/attendance_others").to route_to("attendance_others#index")
    end

    it "routes to #new" do
      expect(:get => "/attendance_others/new").to route_to("attendance_others#new")
    end

    it "routes to #show" do
      expect(:get => "/attendance_others/1").to route_to("attendance_others#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/attendance_others/1/edit").to route_to("attendance_others#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/attendance_others").to route_to("attendance_others#create")
    end

    it "routes to #update" do
      expect(:put => "/attendance_others/1").to route_to("attendance_others#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/attendance_others/1").to route_to("attendance_others#destroy", :id => "1")
    end

  end
end
