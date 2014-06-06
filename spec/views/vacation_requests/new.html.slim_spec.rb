require 'rails_helper'

RSpec.describe "vacation_requests/new", :type => :view do
  before(:each) do
    assign(:vacation_request, VacationRequest.new(
      :user_id => 1,
      :term => 1,
      :category => "MyString",
      :reason => "MyString",
      :note => "MyString",
      :year => "",
      :month => ""
    ))
  end

  it "renders new vacation_request form" do
    render

    assert_select "form[action=?][method=?]", vacation_requests_path, "post" do

      assert_select "input#vacation_request_user_id[name=?]", "vacation_request[user_id]"

      assert_select "input#vacation_request_term[name=?]", "vacation_request[term]"

      assert_select "input#vacation_request_category[name=?]", "vacation_request[category]"

      assert_select "input#vacation_request_reason[name=?]", "vacation_request[reason]"

      assert_select "input#vacation_request_note[name=?]", "vacation_request[note]"

      assert_select "input#vacation_request_year[name=?]", "vacation_request[year]"

      assert_select "input#vacation_request_month[name=?]", "vacation_request[month]"
    end
  end
end
