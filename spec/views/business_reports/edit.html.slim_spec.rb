require 'spec_helper'

describe "business_report/edit" do
  before(:each) do
    # sign_in :user
    @business_report = assign(:business_report, stub_model(BusinessReport,
      :user_id => 1,
      :naiyou => "MyText",
      :jisseki => "MyText",
      :tool => "MyString",
      :self_purpose => "MyString",
      :self_value => "MyString",
      :self_reason => "MyString",
      :user_situation => "MyText",
      :request => "MyText",
      :develop_purpose => "MyString",
      :develop_jisseki => "MyText",
      :note => "MyText"
    ))
  end

  it "renders the edit business_report form" do
    render

    assert_select "form[action=?][method=?]", business_report_path(@business_report), "post" do

      assert_select "input#business_report_user_id[name=?]", "business_report[user_id]"

      assert_select "textarea#business_report_naiyou[name=?]", "business_report[naiyou]"

      assert_select "textarea#business_report_jisseki[name=?]", "business_report[jisseki]"

      assert_select "input#business_report_tool[name=?]", "business_report[tool]"

      assert_select "input#business_report_self_purpose[name=?]", "business_report[self_purpose]"

      assert_select "input#business_report_self_value[name=?]", "business_report[self_value]"

      assert_select "input#business_report_self_reason[name=?]", "business_report[self_reason]"

      assert_select "textarea#business_report_user_situation[name=?]", "business_report[user_situation]"

      assert_select "textarea#business_report_request[name=?]", "business_report[request]"

      assert_select "input#business_report_develop_purpose[name=?]", "business_report[develop_purpose]"

      assert_select "textarea#business_report_develop_jisseki[name=?]", "business_report[develop_jisseki]"

      assert_select "textarea#business_report_note[name=?]", "business_report[note]"
    end
  end
end
