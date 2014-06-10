require 'rails_helper'

RSpec.describe "attendance_others/edit", :type => :view do
  before(:each) do
    @attendance_other = assign(:attendance_other, AttendanceOther.create!(
      :summary => "MyString",
      :over_time => "9.99"
    ))
  end

  it "renders the edit attendance_other form" do
    render

    assert_select "form[action=?][method=?]", attendance_other_path(@attendance_other), "post" do

      assert_select "input#attendance_other_summary[name=?]", "attendance_other[summary]"

      assert_select "input#attendance_other_over_time[name=?]", "attendance_other[over_time]"
    end
  end
end
