require "rails_helper"

RSpec.describe BusinessReportsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/business_reports").to route_to("business_reports#index")
    end

    it "routes to #new" do
      expect(:get => "/business_reports/new").to route_to("business_reports#new")
    end

    it "routes to #show" do
      expect(:get => "/business_reports/1").to route_to("business_reports#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/business_reports/1/edit").to route_to("business_reports#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/business_reports").to route_to("business_reports#create")
    end

    it "routes to #update" do
      expect(:put => "/business_reports/1").to route_to("business_reports#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/business_reports/1").to route_to("business_reports#destroy", :id => "1")
    end

  end
end
