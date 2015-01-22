# -*- coding: utf-8 -*-
class AttendanceInformationController < ApplicationController
  def index

    init

    @years = create_years_collection current_user.attendances
    # temp_years = YearsController.create_years_collection current_user.attendances, session[:years], false
    # if temp_years.blank?
    #   session[:years] = temp_years
    # end

    session[:years] = "#{@nendo}#{@gatudo}"
    logger.debug("session_years"+session[:years])
    
    if current_user.katagaki.role == User::Roles::ADMIN or current_user.katagaki.role == User::Roles::MANAGER
      @users = User.where(section_id: current_user.section_id)
    else
      @users = User.where(id: current_user.id)
    end

    @infos = []
    
    @users.each do |user|
      info = {}
      
      info[:name] = user.family_name + " " + user.first_name

      # 勤務状況報告書
      attendances = user.attendances.where(year: @nendo, month: @gatudo)
      info[:attendances_self_approved] = attendances.exists? && attendances.first.self_approved ? "○" : "×"
      info[:attendances_boss_approved] = attendances.exists? && attendances.first.boss_approved ? "○" : "×"

      # 業務報告書
      reports = user.business_reports.where(year: @nendo, month: @gatudo)
      info[:reports_self_approved] = reports.exists? && reports.first.self_approved ? "○" : "×"
      info[:reports_boss_approved] = reports.exists? && reports.first.boss_approved ? "○" : "×"

      # 交通費精算書(本人)
      expresses = user.transportation_expresses.where(year: @nendo, month: @gatudo)
      if ! expresses.exists?
        info[:expresses_self_approved] = "-"
      elsif expresses.first.self_approved
        info[:expresses_self_approved] = "○"
      else
        info[:expresses_self_approved] = "×"
      end

      # 交通費精算書(上長)
      if ! expresses.exists?
        info[:expresses_boss_approved] = "-"
      elsif expresses.first.boss_approved
        info[:expresses_boss_approved] = "○"
      else
        info[:expresses_boss_approved] = "×"
      end

      # 休暇届(本人)
      vacation = user.vacation_requests.where(year: @nendo, month: @gatudo)
      if ! vacation.exists?
        info[:vacation_self_approved] = "-"
      elsif vacation.first.self_approved
        info[:vacation_self_approved] = "○"
      else
        info[:vacation_self_approved] = "×"
      end

      # 休暇届(上長)
      if ! vacation.exists?
        info[:vacation_boss_approved] = "-"
      elsif vacation.first.boss_approved
        info[:vacation_boss_approved] = "○"
      else
        info[:vacation_boss_approved] = "×"
      end

      # 通勤届(本人)
      commutes = user.commutes.where(year: @nendo, month: @gatudo)
      if ! commutes.exists?
        info[:commutes_self_approved] = "-"
      elsif commutes.first.self_approved
        info[:commutes_self_approved] = "○"
      else
        info[:commutes_self_approved] = "×"
      end

      # 通勤届(上長)
      if ! commutes.exists?
        info[:commutes_boss_approved] = "-"
      elsif commutes.first.boss_approved
        info[:commutes_boss_approved] = "○"
      else
        info[:commutes_boss_approved] = "×"
      end

      # 住宅手当申請書(本人)
      housing = user.housing_allowances.where(year: @nendo, month: @gatudo)
      if ! housing.exists?
        info[:housing_self_approved] = "-"
      elsif housing.first.self_approved
        info[:housing_self_approved] = "○"
      else
        info[:housing_self_approved] = "×"
      end

      # 住宅手当申請書(上長)
      if ! housing.exists?
        info[:housing_boss_approved] = "-"
      elsif housing.first.boss_approved
        info[:housing_boss_approved] = "○"
      else
        info[:housing_boss_approved] = "×"
      end

      # 資格手当申請書(本人)
      qualification = user.qualification_allowances.where(year: @nendo, month: @gatudo)
      if ! qualification.exists?
        info[:qualification_self_approved] = "-"
      elsif qualification.first.self_approved
        info[:qualification_self_approved] = "○"
      else
        info[:qualification_self_approved] = "×"
      end

      # 資格手当申請書(上長)
      if ! qualification.exists?
        info[:qualification_boss_approved] = "-"
      elsif qualification.first.boss_approved
        info[:qualification_boss_approved] = "○"
      else
        info[:qualification_boss_approved] = "×"
      end

      @infos << info
    end

    @infos.each do |info|
      logger.debug("勤怠登録状況照会 ユーザ名: " + info[:name])
    end
  end

  def init(freezed=false)

    logger.debug("init session_years1" + session[:years])
    if changed_years?
      session[:years] = params[:years][:years]
    end
    logger.debug("init session_years2" + session[:years])

    @attendance_years = YearsController.get_years(current_user.attendances, session[:years], freezed)
    
    @nendo = YearsController.get_target_year(@attendance_years)
    @gatudo = YearsController.get_gatudo(@attendance_years)
  end

  # 画面の対象年月が変更されたどうかを判定する
  # @return [Boolean] 対象年月が変更されている場合はtrueを返す。そうでない場合はfalseを返す
  def changed_years?
    return ! params[:years].nil?
  end
end
