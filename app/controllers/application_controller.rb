# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  $role_info = [["管理者", User::Roles::ADMIN], ["マネージャー", User::Roles::MANAGER], ["一般", User::Roles::REGULAR]]

  # 自分が属する課のマネージャーを取得する。
  def getManager()
    manager = User::Roles::MANAGER
    katagaki = Katagaki.where( role: manager)
    temp_user = katagaki[0].users.where(section_id: current_user.section_id)
    temp_user
  end
  
  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) << [:family_name, :first_name, :kana_family_name, :kana_first_name, :section_id, :gender]
      devise_parameter_sanitizer.for(:account_update) << [:family_name, :first_name, :kana_family_name, :kana_first_name, :section_id, :gender,
        :birth_date, :postal_code, :prefecture, :city, :house_number, :building, :phone, :gakureki, :employee_no, :age, :experience,
        :employee_date, :imprint_id, :station, :katagaki_id]
    end

    def get_project
      if current_user.projects.nil?
        Project.new
      else
        current_user.projects.find_by(active: true)
      end
    end

  private

    # Overwriting the sign_out redirect path method
    def after_sign_out_path_for(resource_or_scope)
      root_path
    end
end
