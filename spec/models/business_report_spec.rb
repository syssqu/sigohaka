require 'factory_girl'
require 'spec_helper'

RSpec.describe BusinessReport, :type => :model do
  describe "BusinessReport" do
   	let(:section) { FactoryGirl.create(:section) }
  	let(:user) { FactoryGirl.create(:user) }
	before { @business_report = user.business_reports.build(user_id:"1",
																	naiyou: "aaa",
																	jisseki: "bbb",
																	tool:"ccc",
																	self_purpose:"ddd",
																	self_value: "a",
																	self_reason: "eee",
																	user_situation: "fff",
																	request: "ggg",
																	develop_purpose: "hhh",
																	develop_jisseki: "iii",
																	note: "jjj",
																	reflection: "kkk"
																	) }

	  subject { @business_report }

	  it { should respond_to(:user_id) }
	  it { should respond_to(:naiyou) }
	  it { should respond_to(:jisseki) }
	  it { should respond_to(:tool) }
	  it { should respond_to(:self_purpose) }
	  it { should respond_to(:self_value) }
	  it { should respond_to(:self_reason) }
	  it { should respond_to(:user_situation) }
	  it { should respond_to(:request) }
	  it { should respond_to(:develop_purpose) }
	  it { should respond_to(:develop_jisseki) }
	  it { should respond_to(:note) }
	  it { should respond_to(:reflection) }
	  # it { should respond_to(:user) }

  end
end
