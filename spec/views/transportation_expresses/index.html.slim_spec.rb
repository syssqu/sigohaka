require 'rails_helper'

RSpec.describe "transportation_expresses/index", :type => :view do
  before(:each) do
    assign(:transportation_expresses, [
      TransportationExpress.create!(
        :user_id => 1,
        :destination => "Destination",
        :route => "Route",
        :transport => "Transport",
        :money => 2,
        :note => "Note",
        :sum => 3,
        :year => "Year",
        :month => "Month"
      ),
      TransportationExpress.create!(
        :user_id => 1,
        :destination => "Destination",
        :route => "Route",
        :transport => "Transport",
        :money => 2,
        :note => "Note",
        :sum => 3,
        :year => "Year",
        :month => "Month"
      )
    ])
  end

  it "renders a list of transportation_expresses" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Destination".to_s, :count => 2
    assert_select "tr>td", :text => "Route".to_s, :count => 2
    assert_select "tr>td", :text => "Transport".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Note".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "Year".to_s, :count => 2
    assert_select "tr>td", :text => "Month".to_s, :count => 2
  end
end
