# -*- coding: utf-8 -*-
class YearsController < ApplicationController

  # 対象日付の月度を返す
  # @param [Date] target_date 対象日付
  # @return [Integer] 対象日付の月度
  def YearsController.get_gatudo(target_date)
    gatudo = target_date.month

    if target_date.day > 15
      gatudo = target_date.months_since(1).month
    end

    gatudo
  end
  
  # 対象年度を返す
  # @param [Date] target_date 対象日付
  # @return [Integer] 対象日付の年度
  def YearsController.get_nendo(target_date)
    nendo = target_date.year

    if target_date.month >= 1 and target_date.month < 4
      nendo = target_date.prev_year.year
    end

    nendo
  end

  # 対象年を返す
  # @param [Date] target_date 対象日付
  # @return [Integer] 対象日付の年度
  def YearsController.get_target_year(target_date)
    year = target_date.year

    if target_date.month == 12 and target_date.day > 15
      year = target_date.next_year.year
    end

    year
  end

  # 対象日付の月を返す
  # 対象日付の日が15日以前の場合に先月の月を返す。そうでない場合は当月の月を返す
  # @param [Date] target_date 対象日付
  # @return [Integer] 対象日付の月
  def YearsController.get_month(target_date)
    month = target_date.month

    if target_date.day < 16
      month = target_date.months_ago(1).month
    end

    month
  end

  # 休日かどうかを判定する
  # @param [Date] target_date 対象日付
  # @return [Boolean] 対象日が休日の場合はtrueを返す。そうでない場合はfalseを返す
  def YearsController.holiday?(target_date)
    target_date.wday == 0 or target_date.wday == 6 or target_date.national_holiday?
  end

  # 画面の対象年月が変更されたどうかを判定する
  # @return [Boolean] 対象年月が変更されている場合はtrueを返す。そうでない場合はfalseを返す
  def YearsController.changed_attendance_years?(target)
    if target.nil? or target.blank?
      logger.debug("対象がnil")
      false
    else
      logger.debug("対象が入力済:" + target.to_s)
      true
    end
  end

  # 画面の対象ユーザーが変更されたどうかを判定する
  # @return [Boolean] 対象ユーザーが変更されている場合はtrueを返す。そうでない場合はfalseを返す
  def YearsController.changed_attendance_users?(target)
    if target.nil? or target.blank?
      false
    else
      true
    end
  end
  
  def YearsController.next_years(temp_years, freezed=false)

    if freezed
      temp = temp_years
      
      years = Date.new(temp[0..3].to_i, temp[4..5].to_i, 1)
      next_years = years.next_month
      
      return "#{next_years.year}#{next_years.month}"
    end

    ""
  end

  # 画面に出力する勤怠日付を確定する
  # 締め処理の場合
  #   対象年月の翌月を返す
  # それ以外の場合
  #   対象年月を返す
  # @param [Object] objects
  # @param [Boolean] freezed 呼び出し元が締め処理の場合にtrueを設定する。選択する対象年月を翌月に変更する。
  # @return [Date] 対象勤怠日付
  def YearsController.get_years(objects, temp_years, freezed=false)
    
    unless temp_years.blank?
      temp = temp_years
      years = Date.new(temp[0..3].to_i, temp[4..5].to_i, 1)
    else
      temp = objects.select('year, month').where("freezed = ? and self_approved = ? and boss_approved = ?", false, false, false).group('year, month').order('year, month')
      if temp.exists?
        years = Date.new(temp.first.year.to_i, temp.first.month.to_i, 1)
      else
        years = Date.today
      end
    end

    if freezed
      years.next_month
    else
      years
    end
  end
end
