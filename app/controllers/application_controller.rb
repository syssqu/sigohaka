class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?
  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) << [:family_name, :first_name, :kana_family_name, :kana_first_name, :section_id]
      devise_parameter_sanitizer.for(:account_update) << [:family_name, :first_name, :kana_family_name, :kana_first_name, :section_id]
    end
end
