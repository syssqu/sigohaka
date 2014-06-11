require 'rails_helper'

RSpec.describe "sections/show", :type => :view do
  before(:each) do
    @section = assign(:section, Section.create!(
      :code => "Code",
      :name => "Name",
      :user_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Code/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/1/)
  end
end
