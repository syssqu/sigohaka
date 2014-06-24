require "spec_helper"

describe HousingAllowancesController do
  describe "routing" do

    it "routes to #index" do
      get("/housing_allowances").should route_to("housing_allowances#index")
    end

    it "routes to #new" do
      get("/housing_allowances/new").should route_to("housing_allowances#new")
    end

    it "routes to #show" do
      get("/housing_allowances/1").should route_to("housing_allowances#show", :id => "1")
    end

    it "routes to #edit" do
      get("/housing_allowances/1/edit").should route_to("housing_allowances#edit", :id => "1")
    end

    it "routes to #create" do
      post("/housing_allowances").should route_to("housing_allowances#create")
    end

    it "routes to #update" do
      put("/housing_allowances/1").should route_to("housing_allowances#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/housing_allowances/1").should route_to("housing_allowances#destroy", :id => "1")
    end

  end
end
