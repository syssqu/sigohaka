require 'rails_helper'

RSpec.describe "vacation_requests/show", :type => :view do
  before(:each) do
    @vacation_request = assign(:vacation_request, VacationRequest.create!(
      :user_id => 1,
      :term => 2,
      :category => "Category",
      :reason => "Reason",
      :note => "Note",
      :year => "",
      :month => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Category/)
    expect(rendered).to match(/Reason/)
    expect(rendered).to match(/Note/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
