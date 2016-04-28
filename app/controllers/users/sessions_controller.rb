class Users::SessionsController < Devise::SessionsController

  layout false

  def new
    super
    render :layout => nil
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
