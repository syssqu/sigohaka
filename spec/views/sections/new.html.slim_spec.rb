require 'rails_helper'

RSpec.describe "sections/new", :type => :view do
  before(:each) do
    assign(:section, Section.new(
      :code => "MyString",
      :name => "MyString",
      :user_id => 1
    ))
  end

  it "renders new section form" do
    render

    assert_select "form[action=?][method=?]", sections_path, "post" do

      assert_select "input#section_code[name=?]", "section[code]"

      assert_select "input#section_name[name=?]", "section[name]"

      assert_select "input#section_user_id[name=?]", "section[user_id]"
    end
  end
end
