# -*- coding: utf-8 -*-
class Users::RegistrationsController < Devise::RegistrationsController

  prepend_before_filter :require_no_authentication, :only => [ :cancel]
  prepend_before_filter :authenticate_scope!, :only => [:new, :create ,:edit, :update, :destroy]
  
  def cancel
    super
  end
 
  def create
    super
  end
 
  def destroy
    super
  end

  def new
    super
    # @sections = Section.all.sort_by{|e| e[:name]}
  end

  def edit
    # setting_address_info
    current_user.update_target = params[:target]
    
    if current_user.update_target == "profile"
      @title = "プロフィールの編集"
    elsif current_user.update_target == "password"
      @title = "パスワードの編集"
    end
    
    super
  end

  # def update
  #   # setting_address_info
    
  #   @user = User.find(current_user.id)

  #   successfully_updated = if needs_password?(@user, params)
  #     @user.update_with_password(devise_parameter_sanitizer.sanitize(:account_update))
  #   else
  #     # remove the virtual current_password attribute
  #     # update_without_password doesn't know how to ignore it
  #     params[:user].delete(:current_password)
  #     @user.update_without_password(devise_parameter_sanitizer.sanitize(:account_update))
  #   end

  #   if successfully_updated
  #     set_flash_message :notice, :updated
  #     # Sign in the user bypassing validation in case their password changed
  #     sign_in @user, :bypass => true
  #     # redirect_to after_update_path_for(@user)
  #     redirect_to edit_user_registration_path @user
  #   else
  #     render "edit"
  #   end
  # end
  def update
    
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    current_user.update_target = params[:user][:update_target]
    resource.update_target = params[:user][:update_target]
 
    #if update_resource(resource, account_update_params)
    if resource.update_without_current_password(account_update_params)
      yield resource if block_given?
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, :bypass => true
      redirect_to edit_user_registration_path @user, target: params[:user][:update_target]
      # respond_with resource, :location => after_update_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  private

    # check if we need password to update user data
    # ie if password or email was changed
    # extend this as needed
    def needs_password?(user, params)
      user.email != params[:user][:email] ||
        params[:user][:password].present?
    end

    # def setting_address_info
    #   @_prefecture = ["北海道","青森県","岩手県","宮城県","秋田県","山形県","福島県","茨城県","栃木県","群馬県","埼玉県","千葉県","東京都","神奈川県","山梨県","新潟県","富山県","石川県","福井県","長野県","岐阜県","静岡県","愛知県","三重県","滋賀県","京都府","大阪府","兵庫県","奈良県","和歌山県","鳥取県","島根県","岡山県","広島県","山口県","徳島県","香川県","愛媛県","高知県","福岡県","佐賀県","長崎県","熊本県","大分県","宮崎県","鹿児島県","沖縄県"]
    # end
end
