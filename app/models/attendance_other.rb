class AttendanceOther < ActiveRecord::Base
  belongs_to :user

  attr_accessor :is_negative_other_over_time
  attr_accessor :is_negative_other_holiday_time
  attr_accessor :is_negative_other_midnight_time
  attr_accessor :is_negative_other_break_time
  attr_accessor :is_negative_other_kouzyo_time
  attr_accessor :is_negative_other_work_time

  validates :remarks, length: { maximum: 20 }

  validate :check_negative, on: :update

  def check_negative

    if self.is_negative_other_over_time
      errors[:base] << "超過時間にマイナスの値を入力することはできません."
    end
    if self.is_negative_other_holiday_time
      errors[:base] << "休日時間にマイナスの値を入力することはできません。"
    end
    if self.is_negative_other_midnight_time
      errors[:base] << "深夜時間にマイナスの値を入力することはできません。 "
    end
    if self.is_negative_other_break_time
      errors[:base] << "休憩時間にマイナスの値を入力することはできません。"
    end
    if self.is_negative_other_kouzyo_time
      errors[:base] << "控除時間にマイナスの値を入力することはできません。"
    end
    if self.is_negative_other_work_time
      errors[:base] << "実働時間にマイナスの値を入力することはできません。"
    end

  end

end
