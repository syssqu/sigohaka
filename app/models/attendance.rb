# -*- coding: utf-8 -*-
class Attendance < ActiveRecord::Base
  belongs_to :user

  attr_accessor :nen_gatudo
  attr_accessor :is_blank_start_time
  attr_accessor :is_blank_end_time

  attr_accessor :is_negative_over_time
  attr_accessor :is_negative_holiday_time
  attr_accessor :is_negative_midnight_time
  attr_accessor :is_negative_break_time
  attr_accessor :is_negative_kouzyo_time
  attr_accessor :is_negative_work_time

  # default_scope -> { order('attendance_date') }

  # チェック
  validates :remarks, length: { maximum: 20 }
  validates :year, presence: true
  validates :month, presence: true
  validates :user_id, presence: true

  validate :check_pattern_and_time, on: :update

  def check_pattern_and_time

    # Rails.logger.debug("start_time blank is " + self.is_blank_start_time.to_s)
    # Rails.logger.debug("end_time blank is " + self.is_blank_end_time.to_s)
    # Rails.logger.debug("start_time is " + self.start_time.to_s)
    # Rails.logger.debug("end_time is " + self.end_time.to_s)
    # Rails.logger.debug("pattern blank is " + pattern.blank?.to_s)

    if self.is_blank_start_time and ! self.is_blank_end_time
      errors.add(:start_time, '出退勤時刻のうち退勤時刻のみ入力することはできません。')
    elsif (pattern.blank? and (! self.is_blank_start_time or ! self.is_blank_end_time)) or (! pattern.blank? and (self.is_blank_start_time and self.is_blank_end_time))
      errors.add(:start_time, '勤務パターンと出退勤時刻はセットで入力して下さい。')
    end


    if self.is_negative_over_time
      errors[:base] << "各種時間にマイナスの値を入力することはできません."
    end
    if self.is_negative_holiday_time
      errors[:base] << "休日時間にマイナスの値を入力することはできません。"
    end
    if self.is_negative_midnight_time
      errors[:base] << "深夜時間にマイナスの値を入力することはできません。 "
    end
    if self.is_negative_break_time
      errors[:base] << "休憩時間にマイナスの値を入力することはできません。"
    end
    if self.is_negative_kouzyo_time
      errors[:base] << "控除時間にマイナスの値を入力することはできません。"
    end
    if self.is_negative_work_time
      errors[:base] << "実働時間にマイナスの値を入力することはできません。"
    end




  end




  # ""の場合に00:00に変換されてしまうのでnilに更新しておく
  before_save { self.start_time = self.is_blank_start_time ? nil : start_time }
  before_save { self.end_time = self.is_blank_end_time ? nil : end_time }
  # before_save { self.work_time = self.work_time.nil ? 0 : self.work_time}


  # 自動計算処理
  def calculate(pattern, attendance_start_time, attendance_end_time)

    if pattern.start_time.blank?
      return
    end

    start_hour, start_min = attendance_start_time.split(":").map(&:to_i)
    end_hour, end_min = attendance_end_time.split(":").map(&:to_i)

    Rails.logger.debug("出勤時: " + start_hour.to_s)
    Rails.logger.debug("出勤分: " + start_min.to_s)
    Rails.logger.debug("退勤時: " + end_hour.to_s)
    Rails.logger.debug("退勤分: " + end_min.to_s)

    self.work_time = get_work_time(pattern, start_hour, start_min, end_hour, end_min)
    self.over_time = get_over_time(pattern)

    self.midnight_time = get_midnight_time(start_hour, start_min, end_hour, end_min)
    self.kouzyo_time = get_kouzyo_time(pattern)

    self.tikoku = tikoku?(pattern, start_hour, start_min)
    self.hankekkin = hankekkin?(pattern, start_hour, start_min)
  end

  def init_time_info()
    self.byouketu = false
    self.kekkin = false
    self.hankekkin = false
    self.tikoku = false
    self.soutai = false
    self.gaisyutu = false
    self.tokkyuu = false
    self.furikyuu = false
    self.yuukyuu = false
    self.syuttyou = false
    self.hankyuu = false

    self.over_time = 0
    self.holiday_time = 0
    self.midnight_time = 0
    self.break_time = 0
    self.kouzyo_time = 0
    self.work_time = 0

  end

  private
    # 実働時間算出
    def get_work_time(pattern, start_hour, start_min, end_hour, end_min)

      Rails.logger.debug("実働時間算出");

      pattern_break_time = pattern.break_time.blank? ? 0 : pattern.break_time

      Rails.logger.debug("休憩時間: " + pattern_break_time.to_s)
      # Rails.logger.debug("attendance_break_time: " + (attendance_break_time * 3600).to_s)

      result = (end_hour - start_hour) + ((end_min - start_min) / 60.0) - pattern_break_time

      Rails.logger.debug("実働時間: " + result.to_s)
      result
    end

    # 超過時間算出
    def get_over_time(pattern)
      result = self.work_time - pattern.work_time
      result > 0 ? result : 0
    end

    # 深夜時間算出
    # とりあえず深夜開始時刻を22:00として計算
    def get_midnight_time(start_hour, start_min, end_hour, end_min)

      result = (end_hour - 22) + ((end_min - 0) / 60)
      result > 0 ? result : 0
    end

    # 控除時間算出
    def get_kouzyo_time(pattern)
      result = pattern.work_time - self.work_time
      result > 0 ? result : 0
    end

    # 遅刻かどうかを判定して結果を返す。
    def tikoku?(pattern, start_hour, start_min)

      Rails.logger.debug("遅刻判定処理: ");
      start_time = format("%02d", start_hour) + format("%02d", start_min)

      result = pattern.start_time.strftime("%0H%0M").to_i - start_time.to_i

      Rails.logger.debug("パターン開始時刻: " + pattern.start_time.strftime("%0H%0M"));
      Rails.logger.debug("画面開始時刻: " + start_time.to_i.to_s);
      Rails.logger.debug("結果: " + result.to_s);

      0 > result && result.abs <= 1000 ? true : false
    end

    # 半欠勤かどうを判定して結果を返す。
    def hankekkin?(pattern, start_hour, start_min)

      Rails.logger.debug("半欠勤判定処理: ");
      start_time = format("%02d", start_hour) + format("%02d", start_min)

      result = pattern.start_time.strftime("%_H%_M").to_i - start_time.to_i

      ( self.work_time < pattern.work_time and self.work_time >= pattern.work_time / 2 and result.abs > 1000) ? true : false
    end
end
