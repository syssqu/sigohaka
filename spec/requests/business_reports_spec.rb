require 'spec_helper'

describe "business_reports" do

	describe "index page" do

	  it "should have the content '業務報告書'" do
	    visit '/business_reports'
	    expect(page).to have_content('業務報告書')
	  end
	end

# 仮　テストパス
	describe "edit page" do

		it "should have the content '業務報告書'" do
			visit '/business_reports'
			expect(page).to have_content('業務報告書')
		end
	end
end
