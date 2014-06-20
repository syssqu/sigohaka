require 'spec_helper'

describe "business_reports/index" do

  before(:each) do
    assign(:business_reports, [
      BusinessReport.create!(
      :user_id => 1,
      :naiyou => "MyText",
      :jisseki => "MyText",
      :tool => "Tool",
      :self_purpose => "Self Purpose",
      :self_value => "Self Value",
      :self_reason => "Self Reason",
      :user_situation => "MyText",
      :request => "MyText",
      :develop_purpose => "Develop Purpose",
      :develop_jisseki => "MyText",
      :note => "MyText"
      )
    ])
  end

  it "renders a list of business_reports" do
    render

    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Tool".to_s, :count => 2
    assert_select "tr>td", :text => "Self Purpose".to_s, :count => 2
    assert_select "tr>td", :text => "Self Value".to_s, :count => 2
    assert_select "tr>td", :text => "Self Reason".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Develop Purpose".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
