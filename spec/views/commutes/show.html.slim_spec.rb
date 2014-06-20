require 'spec_helper'

describe "commutes/show" do
  before(:each) do
    @commute = assign(:commute, stub_model(Commute,
      :user_id => 1,
      :year => "Year",
      :month => "Month",
      :reason => "Reason",
      :reason_text => "Reason Text",
      :transport => "Transport",
      :segment1 => "Segment1",
      :segment2 => "Segment2",
      :money => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/Year/)
    rendered.should match(/Month/)
    rendered.should match(/Reason/)
    rendered.should match(/Reason Text/)
    rendered.should match(/Transport/)
    rendered.should match(/Segment1/)
    rendered.should match(/Segment2/)
    rendered.should match(/2/)
  end
end
