require "spec_helper"

describe "routes for Business Reports" do

  it "routes to /business_reports" do
    expect(:get => "/business_reports").to be_routable
  end

  it "routes to #new" do
    expect(:get => "/business_reports/new").to be_routable
  end

  it "routes to #show" do
    expect(:get => "/business_reports/1").to be_routable
  end

  it "routes to #edit" do
    expect(:get => "/business_reports/1/edit").to be_routable
  end

  it "routes to #create" do
    expect(:post => "/business_reports").to be_routable
  end

  it "routes to #update" do
    expect(:put => "/business_reports/1").to be_routable
  end

  it "routes to #destroy" do
    expect(:delete => "/business_reports/1").to be_routable
  end
end
