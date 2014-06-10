require 'rails_helper'

RSpec.describe "attendance_others/index", :type => :view do
  before(:each) do
    assign(:attendance_others, [
      AttendanceOther.create!(
        :summary => "Summary",
        :over_time => "9.99"
      ),
      AttendanceOther.create!(
        :summary => "Summary",
        :over_time => "9.99"
      )
    ])
  end

  it "renders a list of attendance_others" do
    render
    assert_select "tr>td", :text => "Summary".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
  end
end
