require "rails_helper"

RSpec.describe VacationRequestsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/vacation_requests").to route_to("vacation_requests#index")
    end

    it "routes to #new" do
      expect(:get => "/vacation_requests/new").to route_to("vacation_requests#new")
    end

    it "routes to #show" do
      expect(:get => "/vacation_requests/1").to route_to("vacation_requests#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/vacation_requests/1/edit").to route_to("vacation_requests#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/vacation_requests").to route_to("vacation_requests#create")
    end

    it "routes to #update" do
      expect(:put => "/vacation_requests/1").to route_to("vacation_requests#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/vacation_requests/1").to route_to("vacation_requests#destroy", :id => "1")
    end

  end
end
