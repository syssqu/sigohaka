require 'rails_helper'

RSpec.describe "kinmu_patterns/edit", :type => :view do
  before(:each) do
    @kinmu_pattern = assign(:kinmu_pattern, KinmuPattern.create!(
      :break_time => 1,
      :work_time => 1,
      :user_id => 1
    ))
  end

  it "renders the edit kinmu_pattern form" do
    render

    assert_select "form[action=?][method=?]", kinmu_pattern_path(@kinmu_pattern), "post" do

      assert_select "input#kinmu_pattern_break_time[name=?]", "kinmu_pattern[break_time]"

      assert_select "input#kinmu_pattern_work_time[name=?]", "kinmu_pattern[work_time]"

      assert_select "input#kinmu_pattern_user_id[name=?]", "kinmu_pattern[user_id]"
    end
  end
end
