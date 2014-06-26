require 'spec_helper'

describe "qualification_allowances/new" do
  before(:each) do
    assign(:qualification_allowance, stub_model(QualificationAllowance,
      :user_id => 1,
      :number => "MyString",
      :item => "MyString",
      :money => 1
    ).as_new_record)
  end

  it "renders new qualification_allowance form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", qualification_allowances_path, "post" do
      assert_select "input#qualification_allowance_user_id[name=?]", "qualification_allowance[user_id]"
      assert_select "input#qualification_allowance_number[name=?]", "qualification_allowance[number]"
      assert_select "input#qualification_allowance_item[name=?]", "qualification_allowance[item]"
      assert_select "input#qualification_allowance_money[name=?]", "qualification_allowance[money]"
    end
  end
end
