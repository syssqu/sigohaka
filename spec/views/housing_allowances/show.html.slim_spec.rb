require 'spec_helper'

describe "housing_allowances/show" do
  before(:each) do
    @housing_allowance = assign(:housing_allowance, stub_model(HousingAllowance,
      :user_id => 1,
      :year => "Year",
      :month => "Month",
      :reason => "Reason",
      :reason_text => "Reason Text",
      :housing_style => "Housing Style",
      :housing_style_text => "Housing Style Text",
      :spouse => "Spouse",
      :spouse_name => "Spouse Name",
      :spouse_other => "Spouse Other",
      :support => "Support",
      :support_name1 => "Support Name1",
      :support_name2 => "Support Name2",
      :money => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/Year/)
    rendered.should match(/Month/)
    rendered.should match(/Reason/)
    rendered.should match(/Reason Text/)
    rendered.should match(/Housing Style/)
    rendered.should match(/Housing Style Text/)
    rendered.should match(/Spouse/)
    rendered.should match(/Spouse Name/)
    rendered.should match(/Spouse Other/)
    rendered.should match(/Support/)
    rendered.should match(/Support Name1/)
    rendered.should match(/Support Name2/)
    rendered.should match(/2/)
  end
end
