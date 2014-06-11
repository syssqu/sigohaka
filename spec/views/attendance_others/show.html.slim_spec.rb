require 'rails_helper'

RSpec.describe "attendance_others/show", :type => :view do
  before(:each) do
    @attendance_other = assign(:attendance_other, AttendanceOther.create!(
      :summary => "Summary",
      :over_time => "9.99"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Summary/)
    expect(rendered).to match(/9.99/)
  end
end
