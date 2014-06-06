require 'rails_helper'
require 'factory_girl'

RSpec.describe TransportationExpress, :type => :model do
  describe "TransportationExpress" do

	  before { @transportation_express = TransportationExpress.new(user_id:"1",
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
	end
	describe "current_user TransportationExpress" do
		before {@user = User.new( id:"1",
															email:"abc.a.c",
															family_name:"山田",
															first_name:"太郎")}


		describe "カレントユーザーの項目作成の確認" do
			# sign_in users(:user)
			# users.
			# before do
			#   controller.stub!(:current_user).and_return(FactoryGirl.create(:user))
			# end
			# it do
			# 	get :show
   #  	assigns[:user].should eq(subject.current_user)
			# end
			before (:each) do
		    @user = FactoryGirl.create(:user)
		    sign_in @user
		  end
			 describe "GET 'index'" do
		    it "should be successful" do
		      get 'index'
		      response.should be_success
		      assigns[:signin].should == "ok"
		      # pp response
		    end
		    
		    it "all items finded" do
		      FactoryGirl.create(:item)
		      get 'index'
		      response.should be_success
		      assigns[:items].count.should == 1
		      assigns[:items].first.name.should == "Test Item"
		    end
		  end
			
		end

		describe "カレントユーザーの項目閲覧の確認" do

		end
	end
end
