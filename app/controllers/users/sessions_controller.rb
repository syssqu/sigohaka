class Users::SessionsController < Devise::SessionsController
  def new
    super
  end
 
  def create
    super
  end
 
  def destroy
    super
    # session[:user_id] = nil
    # redirect_to root_url
  end
end
