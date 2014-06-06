require 'rails_helper'

RSpec.describe "transportation_expresses/show", :type => :view do
  before(:each) do
    @transportation_express = assign(:transportation_express, TransportationExpress.create!(
      :user_id => 1,
      :destination => "Destination",
      :route => "Route",
      :transport => "Transport",
      :money => 2,
      :note => "Note",
      :sum => 3,
      :year => "Year",
      :month => "Month"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Destination/)
    expect(rendered).to match(/Route/)
    expect(rendered).to match(/Transport/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Note/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/Year/)
    expect(rendered).to match(/Month/)
  end
end
