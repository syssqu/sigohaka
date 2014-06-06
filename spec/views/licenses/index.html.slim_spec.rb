require 'rails_helper'

RSpec.describe "licenses/index", :type => :view do
  before(:each) do
    assign(:licenses, [
      License.create!(
        :code => "Code",
        :name => "Name",
        :years => "Years",
        :user_id => 1
      ),
      License.create!(
        :code => "Code",
        :name => "Name",
        :years => "Years",
        :user_id => 1
      )
    ])
  end

  it "renders a list of licenses" do
    render
    assert_select "tr>td", :text => "Code".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Years".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
