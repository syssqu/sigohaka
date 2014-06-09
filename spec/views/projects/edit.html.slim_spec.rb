require 'rails_helper'

RSpec.describe "projects/edit", :type => :view do
  before(:each) do
    @project = assign(:project, Project.create!(
      :code => "MyString",
      :name => "MyString",
      :remarks => "MyText"
    ))
  end

  it "renders the edit project form" do
    render

    assert_select "form[action=?][method=?]", project_path(@project), "post" do

      assert_select "input#project_code[name=?]", "project[code]"

      assert_select "input#project_name[name=?]", "project[name]"

      assert_select "textarea#project_remarks[name=?]", "project[remarks]"
    end
  end
end