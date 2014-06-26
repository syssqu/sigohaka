require "spec_helper"

describe SummaryAttendancesController do
  describe "routing" do

    it "routes to #index" do
      get("/summary_attendances").should route_to("summary_attendances#index")
    end

    it "routes to #new" do
      get("/summary_attendances/new").should route_to("summary_attendances#new")
    end

    it "routes to #show" do
      get("/summary_attendances/1").should route_to("summary_attendances#show", :id => "1")
    end

    it "routes to #edit" do
      get("/summary_attendances/1/edit").should route_to("summary_attendances#edit", :id => "1")
    end

    it "routes to #create" do
      post("/summary_attendances").should route_to("summary_attendances#create")
    end

    it "routes to #update" do
      put("/summary_attendances/1").should route_to("summary_attendances#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/summary_attendances/1").should route_to("summary_attendances#destroy", :id => "1")
    end

  end
end
