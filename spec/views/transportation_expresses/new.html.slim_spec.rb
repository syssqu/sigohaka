require 'rails_helper'

RSpec.describe "transportation_expresses/new", :type => :view do
  before(:each) do
    assign(:transportation_express, TransportationExpress.new(
      :user_id => 1,
      :destination => "MyString",
      :route => "MyString",
      :transport => "MyString",
      :money => 1,
      :note => "MyString",
      :sum => 1,
      :year => "MyString",
      :month => "MyString"
    ))
  end

  it "renders new transportation_express form" do
    render

    assert_select "form[action=?][method=?]", transportation_expresses_path, "post" do

      assert_select "input#transportation_express_user_id[name=?]", "transportation_express[user_id]"

      assert_select "input#transportation_express_destination[name=?]", "transportation_express[destination]"

      assert_select "input#transportation_express_route[name=?]", "transportation_express[route]"

      assert_select "input#transportation_express_transport[name=?]", "transportation_express[transport]"

      assert_select "input#transportation_express_money[name=?]", "transportation_express[money]"

      assert_select "input#transportation_express_note[name=?]", "transportation_express[note]"

      assert_select "input#transportation_express_sum[name=?]", "transportation_express[sum]"

      assert_select "input#transportation_express_year[name=?]", "transportation_express[year]"

      assert_select "input#transportation_express_month[name=?]", "transportation_express[month]"
    end
  end
end
