require 'rails_helper'

RSpec.describe "kinmu_patterns/show", :type => :view do
  before(:each) do
    @kinmu_pattern = assign(:kinmu_pattern, KinmuPattern.create!(
      :break_time => 1,
      :work_time => 2,
      :user_id => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
  end
end
