# require 'rails_helper'
# -*- coding: utf-8 -*-
require 'factory_girl'
require 'spec_helper'
# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe BusinessReportsController, :type => :controller do
  describe "user" do
     
    describe "login" do

      login_user
      specify "authenticate" do
        
        subject.current_user.should_not be_nil
      end
    end

    describe "add" do
      login_user
     
      let(:business_report){FactoryGirl.create(:business_report,user: @user)}
     
      subject{business_report}

      it { should respond_to(:user_id) }
      it { should be_valid }

      describe "nil user_id" do
        before { business_report.user_id = nil }
        it { should_not be_nil }
      end

      specify "equal user_id" do
        expect(business_report.user_id).to eq @user.id
      end

    end
  end

  describe "action" do
    login_user
    4.times do
      let(:business_report){FactoryGirl.create(:business_report,user: @user)}
    end

    describe "GET 'index'" do

      it "returns http success" do
        get :index
        response.should be_success
      end
    end

    describe "GET 'show'" do

      it "returns http success" do
        get :show, {:id => business_report.id}
        response.should be_success
      end
    end

    describe "GET 'new'" do

      it "returns http success" do
        get 'new'
        response.should be_success
      end
    end

    describe "GET 'edit'" do

      it "returns http success" do
        get :edit, {:id => business_report.id}
        response.should be_success
      end
    end
  end
end


    # describe "POST create" do
    #   describe "with valid params" do
    #     it "creates a new BusinessReport" do
    #       expect {
    #         post :create, {:business_report => valid_attributes}, valid_session
    #       }.to change(BusinessReport, :count).by(1)
    #     end

    #     it "assigns a newly created business_report as @business_report" do
    #       post :create, {:business_report => valid_attributes}, valid_session
    #       expect(assigns(:business_report)).to be_a(BusinessReport)
    #       expect(assigns(:business_report)).to be_persisted
    #     end

    #     it "redirects to the created business_report" do
    #       post :create, {:business_report => valid_attributes}, valid_session
    #       expect(response).to redirect_to(BusinessReport.last)
    #     end
    #   end

    #   describe "with invalid params" do
    #     it "assigns a newly created but unsaved business_report as @business_report" do
    #       post :create, {:business_report => invalid_attributes}, valid_session
    #       expect(assigns(:business_report)).to be_a_new(BusinessReport)
    #     end

    #     it "re-renders the 'new' template" do
    #       post :create, {:business_report => invalid_attributes}, valid_session
    #       expect(response).to render_template("new")
    #     end
    #   end
    # end

    # describe "PUT update" do
    #   describe "with valid params" do
    #     let(:new_attributes) {
    #       skip("Add a hash of attributes valid for your model")
    #     }

    #     it "updates the requested business_report" do
    #       business_report = BusinessReport.create! valid_attributes
    #       put :update, {:id => business_report.to_param, :business_report => new_attributes}, valid_session
    #       business_report.reload
    #       skip("Add assertions for updated state")
    #     end

    #     it "assigns the requested business_report as @business_report" do
    #       business_report = BusinessReport.create! valid_attributes
    #       put :update, {:id => business_report.to_param, :business_report => valid_attributes}, valid_session
    #       expect(assigns(:business_report)).to eq(business_report)
    #     end

    #     it "redirects to the business_report" do
    #       business_report = BusinessReport.create! valid_attributes
    #       put :update, {:id => business_report.to_param, :business_report => valid_attributes}, valid_session
    #       expect(response).to redirect_to(business_report)
    #     end
    #   end

    #   describe "with invalid params" do
    #     it "assigns the business_report as @business_report" do
    #       business_report = BusinessReport.create! valid_attributes
    #       put :update, {:id => business_report.to_param, :business_report => invalid_attributes}, valid_session
    #       expect(assigns(:business_report)).to eq(business_report)
    #     end

    #     it "re-renders the 'edit' template" do
    #       business_report = BusinessReport.create! valid_attributes
    #       put :update, {:id => business_report.to_param, :business_report => invalid_attributes}, valid_session
    #       expect(response).to render_template("edit")
    #     end
    #   end
    # end

    # describe "DELETE destroy" do
    #   it "destroys the requested business_report" do
    #     business_report = BusinessReport.create! valid_attributes
    #     expect {
    #       delete :destroy, {:id => business_report.to_param}, valid_session
    #     }.to change(BusinessReport, :count).by(-1)
    #   end

    #   it "redirects to the business_reports list" do
    #     business_report = BusinessReport.create! valid_attributes
    #     delete :destroy, {:id => business_report.to_param}, valid_session
    #     expect(response).to redirect_to(business_reports_url)
    #   end
    # end
