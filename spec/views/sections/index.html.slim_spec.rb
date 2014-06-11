require 'rails_helper'

RSpec.describe "sections/index", :type => :view do
  before(:each) do
    assign(:sections, [
      Section.create!(
        :code => "Code",
        :name => "Name",
        :user_id => 1
      ),
      Section.create!(
        :code => "Code",
        :name => "Name",
        :user_id => 1
      )
    ])
  end

  it "renders a list of sections" do
    render
    assert_select "tr>td", :text => "Code".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
