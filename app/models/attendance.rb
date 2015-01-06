# -*- coding: utf-8 -*-
class Attendance < ActiveRecord::Base
  belongs_to :user

  attr_accessor :nen_gatudo
  attr_accessor :is_blank_start_time
  attr_accessor :is_blank_end_time

  # default_scope -> { order('attendance_date') }

  # チェック
  validates :remarks, length: { maximum: 20 }
  validates :year, presence: true
  validates :month, presence: true
  validates :user_id, presence: true

  validate :check_pattern_and_time
  
  def check_pattern_and_time

    
    Rails.logger.debug("start_time blank is " + self.is_blank_start_time.to_s)
    Rails.logger.debug("end_time blank is " + self.is_blank_end_time.to_s)

    
    Rails.logger.debug("start_time is " + self.start_time.to_s)
    Rails.logger.debug("end_time is " + self.end_time.to_s)

    Rails.logger.debug("pattern blank is " + pattern.blank?.to_s)
    
    if self.is_blank_start_time and ! self.is_blank_end_time
      errors.add(:start_time, '出退勤時刻のうち退勤時刻のみ入力することはできません。')
    elsif (pattern.blank? and (! self.is_blank_start_time or ! self.is_blank_end_time)) or (! pattern.blank? and (self.is_blank_start_time and self.is_blank_end_time))
      errors.add(:start_time, '勤務パターンと出退勤時刻はセットで入力して下さい。')
    end
  end

  # ""の場合に00:00に変換されてしまうのでnilに更新しておく
  before_save { self.start_time = self.is_blank_start_time ? nil : start_time }
  before_save { self.end_time = self.is_blank_end_time ? nil : end_time }

  # 自動計算処理
  def calculate(pattern, attendance_start_time, attendance_end_time)
    self.work_time = get_work_time(pattern, attendance_start_time, attendance_end_time)
    self.over_time = get_over_time
    self.midnight_time = get_midnight_time(attendance_start_time, attendance_end_time)
    self.kouzyo_time = get_kouzyo_time

    self.tikoku = tikoku?(pattern, attendance_start_time)
    self.hankekkin = hankekkin?(pattern, attendance_start_time)
  end

  private
    # 実働時間算出
    def get_work_time(pattern, attendance_start_time, attendance_end_time)

      pattern_break_time = pattern.break_time.blank? ? 0 : pattern.break_time

      Rails.logger.debug("pattern_break_time: " + (pattern_break_time * 3600).to_s)
      # Rails.logger.debug("attendance_break_time: " + (attendance_break_time * 3600).to_s)

      result = (attendance_end_time - attendance_start_time - (pattern_break_time * 3600)) / 3600
    end
  
    # 超過時間算出
    def get_over_time
      result = self.work_time - 8.00
      result > 0 ? result : 0
    end

    # 深夜時間算出
    def get_midnight_time(attendance_start_time, attendance_end_time)
      start_midnight_time = Time.local(attendance_start_time.year, attendance_start_time.month, attendance_start_time.day, 22, 0, 0)
      end_midnight_time = Time.local(attendance_end_time.year, attendance_end_time.month, attendance_end_time.day+1, 5, 0, 0)

      result = (attendance_end_time - start_midnight_time) / 3600
      result > 0 ? result : 0
    end

    # 控除時間算出
    def get_kouzyo_time
      result = 8.00 - self.work_time
      result > 0 ? result : 0
    end

    # 遅刻かどうを判定して結果を返す。
    def tikoku?(pattern, attendance_start_time)
      result = (pattern.start_time - attendance_start_time) / 3600
      ( 0 > result and result.abs  < 1) ? true : false
    end

    # 半欠勤かどうを判定して結果を返す。
    def hankekkin?(pattern, attendance_start_time)
      result = (pattern.start_time - attendance_start_time) / 3600
      ( 0 > result and result.abs >= 1) ? true : false
    end
end
