class Users::SessionsController < Devise::SessionsController

  layout false
  
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

    session[:years] = nil
    session[:target_user] = nil
  end
end
