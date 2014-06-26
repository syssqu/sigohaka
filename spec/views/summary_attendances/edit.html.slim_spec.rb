require 'spec_helper'

describe "summary_attendances/edit" do
  before(:each) do
    @summary_attendance = assign(:summary_attendance, stub_model(SummaryAttendance,
      :user_id => 1,
      :year => "MyString",
      :month => "MyString",
      :previous_m => 1,
      :present_m => 1,
      :vacation => 1,
      :half_holiday => 1
    ))
  end

  it "renders the edit summary_attendance form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", summary_attendance_path(@summary_attendance), "post" do
      assert_select "input#summary_attendance_user_id[name=?]", "summary_attendance[user_id]"
      assert_select "input#summary_attendance_year[name=?]", "summary_attendance[year]"
      assert_select "input#summary_attendance_month[name=?]", "summary_attendance[month]"
      assert_select "input#summary_attendance_previous_m[name=?]", "summary_attendance[previous_m]"
      assert_select "input#summary_attendance_present_m[name=?]", "summary_attendance[present_m]"
      assert_select "input#summary_attendance_vacation[name=?]", "summary_attendance[vacation]"
      assert_select "input#summary_attendance_half_holiday[name=?]", "summary_attendance[half_holiday]"
    end
  end
end
