# -*- coding: utf-8 -*-

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  $role_info = [["管理者", User::Roles::ADMIN], ["マネージャー", User::Roles::MANAGER], ["一般", User::Roles::REGULAR]]

  def after_sign_in_path_for(resource)
    home_path
  end
  #
  # 勤怠登録されている年月を返す
  #
  def create_years_collection(objects, freezed=false)
    logger.debug("create_years_collection")

    # result = objects.select("year ||  month as id, year || '年' || month || '月度' as value").group('year, month').order("id DESC")
    #
    # if result.blank?
    #   result = VacationRequest.find_by_sql(["select to_char(now(), 'YYYY') || to_char(now(), 'FMMM') as id, to_char(now(), 'YYYY') || '年' ||  to_char(now(), 'FMMM') || '月度' as value"])
    # end

    result = {}

    temp = session[:years]
    years = Date.new(temp[0..3].to_i, temp[4..5].to_i, 1)
    # years = Date.today
    result.store("#{years.year}年#{years.month.to_s.rjust(2, '0')}月度", "#{years.year}#{years.month}")

    5.times do
      years = years.last_month
      result.store("#{years.year}年#{years.month.to_s.rjust(2, '0')}月度", "#{years.year}#{years.month}")
    end

    years = Date.new(temp[0..3].to_i, temp[4..5].to_i, 1)
    5.times do
      years = years.next_month
      result.store("#{years.year}年#{years.month.to_s.rjust(2, '0')}月度", "#{years.year}#{years.month}")
    end

    Hash[ result.sort ]
  end

  #
  # 自身が所属する課のユーザーを返す
  #
  def create_users_collection
    return User.select("id, family_name || ' ' || first_name as value").where(section_id: current_user.section_id).order("family_name, first_name")
  end

  #
  # 課の情報を返す
  #
  def create_sections_collection
    return Section.select("id, name as value").order("code")
  end

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
      if view_context.target_user.projects.nil?
        Project.new
      else
        view_context.target_user.projects.find_by(active: true)
      end
    end

  private

    # Overwriting the sign_out redirect path method
    def after_sign_out_path_for(resource_or_scope)
      root_path
    end
end
