require 'factory_girl'
require 'spec_helper'

RSpec.describe TransportationExpress, :type => :model do
  describe "TransportationExpress" do
  	let(:section) { FactoryGirl.create(:section) }
  	let(:user) { FactoryGirl.create(:user) }	
	before { @transportation_express = user.transportation_expresses.build(user_id:"1",
																	koutu_date: "2014/4/12",
																	destination: "aaa",
																	route:"bbb",
																	transport:"ccc",
																	money: "5",
																	note: "ddd",
																	sum: "0",
																	year: "1111",
																	month: "22"
																	) }

	  subject { @transportation_express }

	  it { should respond_to(:user_id) }
	  it { should respond_to(:koutu_date) }
	  it { should respond_to(:destination) }
	  it { should respond_to(:route) }
	  it { should respond_to(:transport) }
	  it { should respond_to(:money) }
	  it { should respond_to(:note) }
	  it { should respond_to(:sum) }
	  it { should respond_to(:year) }
	  it { should respond_to(:month) }
	  it { should respond_to(:user) }
		# its(:user) { should eq user }

	end
end