require "spec_helper"

describe CommutesController do
  describe "routing" do

    it "routes to #index" do
      get("/commutes").should route_to("commutes#index")
    end

    it "routes to #new" do
      get("/commutes/new").should route_to("commutes#new")
    end

    it "routes to #show" do
      get("/commutes/1").should route_to("commutes#show", :id => "1")
    end

    it "routes to #edit" do
      get("/commutes/1/edit").should route_to("commutes#edit", :id => "1")
    end

    it "routes to #create" do
      post("/commutes").should route_to("commutes#create")
    end

    it "routes to #update" do
      put("/commutes/1").should route_to("commutes#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/commutes/1").should route_to("commutes#destroy", :id => "1")
    end

  end
end
