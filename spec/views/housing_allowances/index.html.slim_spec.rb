require 'spec_helper'

describe "housing_allowances/index" do
  before(:each) do
    assign(:housing_allowances, [
      stub_model(HousingAllowance,
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
      ),
      stub_model(HousingAllowance,
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
      )
    ])
  end

  it "renders a list of housing_allowances" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Year".to_s, :count => 2
    assert_select "tr>td", :text => "Month".to_s, :count => 2
    assert_select "tr>td", :text => "Reason".to_s, :count => 2
    assert_select "tr>td", :text => "Reason Text".to_s, :count => 2
    assert_select "tr>td", :text => "Housing Style".to_s, :count => 2
    assert_select "tr>td", :text => "Housing Style Text".to_s, :count => 2
    assert_select "tr>td", :text => "Spouse".to_s, :count => 2
    assert_select "tr>td", :text => "Spouse Name".to_s, :count => 2
    assert_select "tr>td", :text => "Spouse Other".to_s, :count => 2
    assert_select "tr>td", :text => "Support".to_s, :count => 2
    assert_select "tr>td", :text => "Support Name1".to_s, :count => 2
    assert_select "tr>td", :text => "Support Name2".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end


  
end
