require 'rails_helper'

RSpec.describe "kinmu_patterns/new", :type => :view do
  before(:each) do
    assign(:kinmu_pattern, KinmuPattern.new(
      :break_time => 1,
      :work_time => 1,
      :user_id => 1
    ))
  end

  it "renders new kinmu_pattern form" do
    render

    assert_select "form[action=?][method=?]", kinmu_patterns_path, "post" do

      assert_select "input#kinmu_pattern_break_time[name=?]", "kinmu_pattern[break_time]"

      assert_select "input#kinmu_pattern_work_time[name=?]", "kinmu_pattern[work_time]"

      assert_select "input#kinmu_pattern_user_id[name=?]", "kinmu_pattern[user_id]"
    end
  end
end
