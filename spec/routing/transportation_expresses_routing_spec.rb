require "rails_helper"

RSpec.describe TransportationExpressesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/transportation_expresses").to route_to("transportation_expresses#index")
    end

    it "routes to #new" do
      expect(:get => "/transportation_expresses/new").to route_to("transportation_expresses#new")
    end

    it "routes to #show" do
      expect(:get => "/transportation_expresses/1").to route_to("transportation_expresses#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/transportation_expresses/1/edit").to route_to("transportation_expresses#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/transportation_expresses").to route_to("transportation_expresses#create")
    end

    it "routes to #update" do
      expect(:put => "/transportation_expresses/1").to route_to("transportation_expresses#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/transportation_expresses/1").to route_to("transportation_expresses#destroy", :id => "1")
    end

  end
end
