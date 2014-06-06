require 'rails_helper'

RSpec.describe "licenses/new", :type => :view do
  before(:each) do
    assign(:license, License.new(
      :code => "MyString",
      :name => "MyString",
      :years => "MyString",
      :user_id => 1
    ))
  end

  it "renders new license form" do
    render

    assert_select "form[action=?][method=?]", licenses_path, "post" do

      assert_select "input#license_code[name=?]", "license[code]"

      assert_select "input#license_name[name=?]", "license[name]"

      assert_select "input#license_years[name=?]", "license[years]"

      assert_select "input#license_user_id[name=?]", "license[user_id]"
    end
  end
end
