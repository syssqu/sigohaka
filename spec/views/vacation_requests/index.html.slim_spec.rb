require 'rails_helper'

RSpec.describe "vacation_requests/index", :type => :view do
  before(:each) do
    assign(:vacation_requests, [
      VacationRequest.create!(
        :user_id => 1,
        :term => 2,
        :category => "Category",
        :reason => "Reason",
        :note => "Note",
        :year => "",
        :month => ""
      ),
      VacationRequest.create!(
        :user_id => 1,
        :term => 2,
        :category => "Category",
        :reason => "Reason",
        :note => "Note",
        :year => "",
        :month => ""
      )
    ])
  end

  it "renders a list of vacation_requests" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Category".to_s, :count => 2
    assert_select "tr>td", :text => "Reason".to_s, :count => 2
    assert_select "tr>td", :text => "Note".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
