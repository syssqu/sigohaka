require 'rails_helper'

RSpec.describe "projects/new", :type => :view do
  before(:each) do
    assign(:project, Project.new(
      :code => "MyString",
      :name => "MyString",
      :remarks => "MyText"
    ))
  end

  it "renders new project form" do
    render

    assert_select "form[action=?][method=?]", projects_path, "post" do

      assert_select "input#project_code[name=?]", "project[code]"

      assert_select "input#project_name[name=?]", "project[name]"

      assert_select "textarea#project_remarks[name=?]", "project[remarks]"
    end
  end
end
