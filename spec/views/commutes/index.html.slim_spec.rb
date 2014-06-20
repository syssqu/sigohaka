require 'spec_helper'

describe "commutes/index" do
  before(:each) do
    assign(:commutes, [
      stub_model(Commute,
        :user_id => 1,
        :year => "Year",
        :month => "Month",
        :reason => "Reason",
        :reason_text => "Reason Text",
        :transport => "Transport",
        :segment1 => "Segment1",
        :segment2 => "Segment2",
        :money => 2
      ),
      stub_model(Commute,
        :user_id => 1,
        :year => "Year",
        :month => "Month",
        :reason => "Reason",
        :reason_text => "Reason Text",
        :transport => "Transport",
        :segment1 => "Segment1",
        :segment2 => "Segment2",
        :money => 2
      )
    ])
  end

  it "renders a list of commutes" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Year".to_s, :count => 2
    assert_select "tr>td", :text => "Month".to_s, :count => 2
    assert_select "tr>td", :text => "Reason".to_s, :count => 2
    assert_select "tr>td", :text => "Reason Text".to_s, :count => 2
    assert_select "tr>td", :text => "Transport".to_s, :count => 2
    assert_select "tr>td", :text => "Segment1".to_s, :count => 2
    assert_select "tr>td", :text => "Segment2".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
