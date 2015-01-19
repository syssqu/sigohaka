require 'spec_helper'
require 'factory_girl'

RSpec.describe HousingAllowance, :type => :model do
  describe "HousingAllowance関連、存在" do
  	let(:user){FactoryGirl.create(:user)}
  	let(:housing_allowance){FactoryGirl.create(:housing_allowance,user: user)}
  	subject { housing_allowance }

  	it { should respond_to(:reason)}
  	it { should respond_to(:reason_text)}
  	it { should respond_to(:housing_style)}
  	it { should respond_to(:housing_style_text)}
  	it { should respond_to(:agree_date_s)}
  	it { should respond_to(:agree_date_e)}
  	it { should respond_to(:spouse)}
  	it { should respond_to(:spouse_name)}
  	it { should respond_to(:spouse_other)}
  	it { should respond_to(:support)}
  	it { should respond_to(:support_name1)}
  	it { should respond_to(:support_name2)}
    it { should respond_to(:freezed)}
    it { should respond_to(:self_approved)}
    it { should respond_to(:boss_approved)}
  end
end
