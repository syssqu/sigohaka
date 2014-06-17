require 'factory_girl'
module ControllerMacros
  def login_user
    before(:each) do
      # controller.stub(:authenticate_user!).and_return true
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = FactoryGirl.create(:user)
      # controller.stub!(:current_user).and_return(@user)
      sign_in @user
    end
  end
end