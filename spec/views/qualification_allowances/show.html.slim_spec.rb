require 'spec_helper'

describe "qualification_allowances/show" do
  before(:each) do
    @qualification_allowance = assign(:qualification_allowance, stub_model(QualificationAllowance,
      :user_id => 1,
      :number => "Number",
      :item => "Item",
      :money => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/Number/)
    rendered.should match(/Item/)
    rendered.should match(/2/)
  end
end
