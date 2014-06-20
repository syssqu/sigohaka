require 'spec_helper'
require 'factory_girl'

describe ReasonsController do

  let(:user){FactoryGirl.create(:user)}
  let(:user2){FactoryGirl.create(:user)}
  let(:reason){FactoryGirl.create(:reason,user: user )}
  let(:reason2){FactoryGirl.create(:reason,user: user2 )}
  describe "GET 'edit'" do
    it "returns http success" do
      sign_in user
      get :edit,{:id => reason.to_param}
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it "returns http success" do
      sign_in user
      get 'new'
      response.should be_success
    end
    
  end

end
