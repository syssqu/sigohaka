require 'factory_girl'
require 'spec_helper'

describe 'ユーザー:' do
  # let(:section) { FactoryGirl.create(:section) }
	let(:user){ FactoryGirl.create(:user) }

  specify '妥当なオブジェクト' do  
    expect(user).to be_valid  
  end  
  
  %w{family_name kana_family_name first_name kana_first_name email gender section_id}.each do |column_name|  
    specify "#{column_name} は空であってはならない" do  
      user[column_name] = ''  
      expect(user).not_to be_valid  
      expect(user.errors[column_name]).to be_present  
    end  
  end
end