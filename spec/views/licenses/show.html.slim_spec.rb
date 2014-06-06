require 'rails_helper'

RSpec.describe "licenses/show", :type => :view do
  before(:each) do
    @license = assign(:license, License.create!(
      :code => "Code",
      :name => "Name",
      :years => "Years",
      :user_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Code/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Years/)
    expect(rendered).to match(/1/)
  end
end
