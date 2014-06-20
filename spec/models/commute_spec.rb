require 'spec_helper'
require 'factory_girl'

RSpec.describe Commute, :type => :model do
  describe "Commute関連付け" do
    let(:section) { FactoryGirl.create(:section) }
    let(:user){FactoryGirl.create(:user)}
    let(:commute){FactoryGirl.create(:commute,user: user)} 
    subject { commute }

    it { should respond_to(:user_id) }
    it { should respond_to(:transport) }
    it { should respond_to(:segment1) }
    it { should respond_to(:segment2) }
    it { should respond_to(:money) }
    # its(:user) { should eq user }

  end
end
