class Users::PasswordsController < Devise::PasswordsController

  def create
    logger.debug("devise password create")
    super
  end

  def new
    super
    render :layout => nil
  end

  def edit
    logger.debug("devise password edit")
    super
  end

  def update
    # @user = current_user

    # # Devise::Models::DatabaseAuthenticatable#update_with_password
    # # Update record attributes when :current_password matches, otherwise returns error on :current_password.
    # # It also automatically rejects :password and :password_confirmation if they are blank.
    # if @user.update_with_password(params[:user])

    #   # Sign in the user bypassing validation in case his password changed
    #   sign_in @user, :bypass => true

    #   redirect_to root_path, :notice => "Your Password has been updated!"
    # else

    #   flash[:alert] = @user.errors.full_messages.join("<br />")
    #   render :edit

    # end
    super
  end


end
