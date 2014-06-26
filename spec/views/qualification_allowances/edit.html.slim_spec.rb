require 'spec_helper'

describe "qualification_allowances/edit" do
  before(:each) do
    @qualification_allowance = assign(:qualification_allowance, stub_model(QualificationAllowance,
      :user_id => 1,
      :number => "MyString",
      :item => "MyString",
      :money => 1
    ))
  end

  it "renders the edit qualification_allowance form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", qualification_allowance_path(@qualification_allowance), "post" do
      assert_select "input#qualification_allowance_user_id[name=?]", "qualification_allowance[user_id]"
      assert_select "input#qualification_allowance_number[name=?]", "qualification_allowance[number]"
      assert_select "input#qualification_allowance_item[name=?]", "qualification_allowance[item]"
      assert_select "input#qualification_allowance_money[name=?]", "qualification_allowance[money]"
    end
  end
end
