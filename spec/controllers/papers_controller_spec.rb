require 'spec_helper'

describe PapersController do

  describe "GET 'freeze'" do
    it "returns http success" do
      get 'freeze'
      response.should be_success
    end
  end

  describe "GET 'unfreeze'" do
    it "returns http success" do
      get 'unfreeze'
      response.should be_success
    end
  end

  describe "GET 'print'" do
    it "returns http success" do
      get 'print'
      response.should be_success
    end
  end

  describe "GET 'approve'" do
    it "returns http success" do
      get 'approve'
      response.should be_success
    end
  end

  describe "GET 'discard'" do
    it "returns http success" do
      get 'discard'
      response.should be_success
    end
  end

  describe "GET 'check'" do
    it "returns http success" do
      get 'check'
      response.should be_success
    end
  end

end
