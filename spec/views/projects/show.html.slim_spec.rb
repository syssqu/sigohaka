require 'rails_helper'

RSpec.describe "projects/show", :type => :view do
  before(:each) do
    @project = assign(:project, Project.create!(
      :code => "Code",
      :name => "Name",
      :remarks => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Code/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
  end
end
