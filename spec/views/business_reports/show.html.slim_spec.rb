require 'rails_helper'

RSpec.describe "business_reports/show", :type => :view do
  before(:each) do
    @business_report = assign(:business_report, BusinessReport.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Tool/)
    expect(rendered).to match(/Self Purpose/)
    expect(rendered).to match(/Self Value/)
    expect(rendered).to match(/Self Reason/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Develop Purpose/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
  end
end
