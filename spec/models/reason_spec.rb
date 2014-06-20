require 'spec_helper'
require 'factory_girl'

RSpec.describe Commute, :type => :model do
  describe "Commute関連付け" do
    let(:section) { FactoryGirl.create(:section) }
    let(:user){FactoryGirl.create(:user)}
    let(:reason){FactoryGirl.create(:reason,user: user)} 
    subject { reason }

    it { should respond_to(:user_id) }
    it { should respond_to(:reason) }
    it { should respond_to(:reason_text) }

  end
end