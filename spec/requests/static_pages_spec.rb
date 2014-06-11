# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Static pages" do

  describe "Home page" do

    it "should have the content 'ようこそ'" do
      visit root_path
      expect(page).to have_content('ようこそ')
    end
  end
end
