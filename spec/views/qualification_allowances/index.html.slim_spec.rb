require 'spec_helper'

describe "qualification_allowances/index" do
  before(:each) do
    assign(:qualification_allowances, [
      stub_model(QualificationAllowance,
        :user_id => 1,
        :number => "Number",
        :item => "Item",
        :money => 2
      ),
      stub_model(QualificationAllowance,
        :user_id => 1,
        :number => "Number",
        :item => "Item",
        :money => 2
      )
    ])
  end

  it "renders a list of qualification_allowances" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Number".to_s, :count => 2
    assert_select "tr>td", :text => "Item".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
