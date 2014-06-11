require 'rails_helper'

RSpec.describe "kinmu_patterns/index", :type => :view do
  before(:each) do
    assign(:kinmu_patterns, [
      KinmuPattern.create!(
        :break_time => 1,
        :work_time => 2,
        :user_id => 3
      ),
      KinmuPattern.create!(
        :break_time => 1,
        :work_time => 2,
        :user_id => 3
      )
    ])
  end

  it "renders a list of kinmu_patterns" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
