require 'spec_helper'

describe "commutes/new" do
  before(:each) do
    assign(:commute, stub_model(Commute,
      :user_id => 1,
      :year => "MyString",
      :month => "MyString",
      :reason => "MyString",
      :reason_text => "MyString",
      :transport => "MyString",
      :segment1 => "MyString",
      :segment2 => "MyString",
      :money => 1
    ).as_new_record)
  end

  it "renders new commute form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", commutes_path, "post" do
      assert_select "input#commute_user_id[name=?]", "commute[user_id]"
      assert_select "input#commute_year[name=?]", "commute[year]"
      assert_select "input#commute_month[name=?]", "commute[month]"
      assert_select "input#commute_reason[name=?]", "commute[reason]"
      assert_select "input#commute_reason_text[name=?]", "commute[reason_text]"
      assert_select "input#commute_transport[name=?]", "commute[transport]"
      assert_select "input#commute_segment1[name=?]", "commute[segment1]"
      assert_select "input#commute_segment2[name=?]", "commute[segment2]"
      assert_select "input#commute_money[name=?]", "commute[money]"
    end
  end
end
