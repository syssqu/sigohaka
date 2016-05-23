class Project < ActiveRecord::Base
  belongs_to :user

  validates :summary, presence: true, length: { maximum: 40}
  validates :start_date, presence: true
  validate :start_end_check

  def start_end_check

    if !self.end_date.blank? && self.start_date > self.end_date
      errors[:base] << "開始月もしくは終了月の日付が正しくありません。"
    end
  end

end
