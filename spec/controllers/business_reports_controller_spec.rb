# require 'rails_helper'
# -*- coding: utf-8 -*-
require 'factory_girl'
require 'spec_helper'

describe BusinessReportsController do
  let(:user){FactoryGirl.create(:user)}
  let(:business_report){FactoryGirl.create(:business_report,user: user)}
  let(:valid_attributes) { { "user_id" => "1" } }
  let(:valid_session) { {} }

  describe "action" do

    describe "GET index" do

      describe "not login" do
        it "denied" do
          get :index, {}, valid_session
          expect(response).to_not be_success

        end
      end
      describe "login" do
        it "assigns all business_report as @business_report" do
          sign_in user
          get :index, {}, valid_session
        end

        it "current_user's index exists" do
          sign_in user
          get :index, {}, valid_session
          expect(business_report.user_id).to eq(subject.current_user.id)
        end

        it "access path" do
          sign_in user
          get :index, {}, valid_session
          expect(response).to be_success    
        end

        it "login(like current_user)" do
          expect(@user).to eq(subject.current_user)
        end
      end
    end

    # describe "GET show" do
    #   it "not login" do
    #     get :show, {:id => business_report.id}, valid_session
    #     expect(response).to_not be_success

    #   end

    #   describe "login" do
    #     it "access path" do
    #       sign_in user
    #       get :show
    #       expect(response).to be_success
    #     end
    #     it "login confirm" do
    #       sign_in user
    #       expect(user.id).to eq(subject.current_user.id)
    #     end
    #   end
    # end
  
    describe "GET new" do
      it "assigns a new business_report as @business_report" do
        sign_in user
        get :new, {}, valid_session
        assigns(:business_report).should be_a_new(BusinessReport)
        response.should be_success
      end
    end

    describe "GET edit" do
      it "assigns the requested business_report as @business_report" do
        sign_in user
        get :edit, {:id => business_report.id}, valid_session
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
