require 'spec_helper'

describe "housing_allowances/edit" do
  before(:each) do
    @housing_allowance = assign(:housing_allowance, stub_model(HousingAllowance,
      :user_id => 1,
      :year => "MyString",
      :month => "MyString",
      :reason => "MyString",
      :reason_text => "MyString",
      :housing_style => "MyString",
      :housing_style_text => "MyString",
      :spouse => "MyString",
      :spouse_name => "MyString",
      :spouse_other => "MyString",
      :support => "MyString",
      :support_name1 => "MyString",
      :support_name2 => "MyString",
      :money => 1
    ))
  end

  it "renders the edit housing_allowance form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", housing_allowance_path(@housing_allowance), "post" do
      assert_select "input#housing_allowance_user_id[name=?]", "housing_allowance[user_id]"
      assert_select "input#housing_allowance_year[name=?]", "housing_allowance[year]"
      assert_select "input#housing_allowance_month[name=?]", "housing_allowance[month]"
      assert_select "input#housing_allowance_reason[name=?]", "housing_allowance[reason]"
      assert_select "input#housing_allowance_reason_text[name=?]", "housing_allowance[reason_text]"
      assert_select "input#housing_allowance_housing_style[name=?]", "housing_allowance[housing_style]"
      assert_select "input#housing_allowance_housing_style_text[name=?]", "housing_allowance[housing_style_text]"
      assert_select "input#housing_allowance_spouse[name=?]", "housing_allowance[spouse]"
      assert_select "input#housing_allowance_spouse_name[name=?]", "housing_allowance[spouse_name]"
      assert_select "input#housing_allowance_spouse_other[name=?]", "housing_allowance[spouse_other]"
      assert_select "input#housing_allowance_support[name=?]", "housing_allowance[support]"
      assert_select "input#housing_allowance_support_name1[name=?]", "housing_allowance[support_name1]"
      assert_select "input#housing_allowance_support_name2[name=?]", "housing_allowance[support_name2]"
      assert_select "input#housing_allowance_money[name=?]", "housing_allowance[money]"
    end
  end
end
