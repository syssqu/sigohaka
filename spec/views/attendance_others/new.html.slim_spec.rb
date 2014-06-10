require 'rails_helper'

RSpec.describe "attendance_others/new", :type => :view do
  before(:each) do
    assign(:attendance_other, AttendanceOther.new(
      :summary => "MyString",
      :over_time => "9.99"
    ))
  end

  it "renders new attendance_other form" do
    render

    assert_select "form[action=?][method=?]", attendance_others_path, "post" do

      assert_select "input#attendance_other_summary[name=?]", "attendance_other[summary]"

      assert_select "input#attendance_other_over_time[name=?]", "attendance_other[over_time]"
    end
  end
end
