require "rails_helper"

RSpec.describe KinmuPatternsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/kinmu_patterns").to route_to("kinmu_patterns#index")
    end

    it "routes to #new" do
      expect(:get => "/kinmu_patterns/new").to route_to("kinmu_patterns#new")
    end

    it "routes to #show" do
      expect(:get => "/kinmu_patterns/1").to route_to("kinmu_patterns#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/kinmu_patterns/1/edit").to route_to("kinmu_patterns#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/kinmu_patterns").to route_to("kinmu_patterns#create")
    end

    it "routes to #update" do
      expect(:put => "/kinmu_patterns/1").to route_to("kinmu_patterns#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/kinmu_patterns/1").to route_to("kinmu_patterns#destroy", :id => "1")
    end

  end
end
