require 'spec_helper'

describe "summary_attendances/show" do
  before(:each) do
    @summary_attendance = assign(:summary_attendance, stub_model(SummaryAttendance,
      :user_id => 1,
      :year => "Year",
      :month => "Month",
      :previous_m => 2,
      :present_m => 3,
      :vacation => 4,
      :half_holiday => 5
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/Year/)
    rendered.should match(/Month/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/4/)
    rendered.should match(/5/)
  end
end
