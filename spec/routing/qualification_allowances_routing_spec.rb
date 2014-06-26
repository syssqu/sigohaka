require "spec_helper"

describe QualificationAllowancesController do
  describe "routing" do

    it "routes to #index" do
      get("/qualification_allowances").should route_to("qualification_allowances#index")
    end

    it "routes to #new" do
      get("/qualification_allowances/new").should route_to("qualification_allowances#new")
    end

    it "routes to #show" do
      get("/qualification_allowances/1").should route_to("qualification_allowances#show", :id => "1")
    end

    it "routes to #edit" do
      get("/qualification_allowances/1/edit").should route_to("qualification_allowances#edit", :id => "1")
    end

    it "routes to #create" do
      post("/qualification_allowances").should route_to("qualification_allowances#create")
    end

    it "routes to #update" do
      put("/qualification_allowances/1").should route_to("qualification_allowances#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/qualification_allowances/1").should route_to("qualification_allowances#destroy", :id => "1")
    end

  end
end
