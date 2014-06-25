require 'spec_helper'

describe "summary_attendances/index" do
  before(:each) do
    assign(:summary_attendances, [
      stub_model(SummaryAttendance,
        :user_id => 1,
        :year => "Year",
        :month => "Month",
        :previous_m => 2,
        :present_m => 3,
        :vacation => 4,
        :half_holiday => 5
      ),
      stub_model(SummaryAttendance,
        :user_id => 1,
        :year => "Year",
        :month => "Month",
        :previous_m => 2,
        :present_m => 3,
        :vacation => 4,
        :half_holiday => 5
      )
    ])
  end

  it "renders a list of summary_attendances" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Year".to_s, :count => 2
    assert_select "tr>td", :text => "Month".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
  end
end
