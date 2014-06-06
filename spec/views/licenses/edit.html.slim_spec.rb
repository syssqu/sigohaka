require 'rails_helper'

RSpec.describe "licenses/edit", :type => :view do
  before(:each) do
    @license = assign(:license, License.create!(
      :code => "MyString",
      :name => "MyString",
      :years => "MyString",
      :user_id => 1
    ))
  end

  it "renders the edit license form" do
    render

    assert_select "form[action=?][method=?]", license_path(@license), "post" do

      assert_select "input#license_code[name=?]", "license[code]"

      assert_select "input#license_name[name=?]", "license[name]"

      assert_select "input#license_years[name=?]", "license[years]"

      assert_select "input#license_user_id[name=?]", "license[user_id]"
    end
  end
end
