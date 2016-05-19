class Project < ActiveRecord::Base
  belongs_to :user

  validates :summary, presence: true, length: { maximum: 40}
  validates :start_date, presence: true
  validate :start_end_check

  def start_end_check
    errors[:base] << "開始月もしくは終了月の日付が正しくありません。"  if
    self.start_date > self.end_date
  end

  def end_check
    errors[:base] << "終了月の年を入力してください。"
    self.end_date == null
  end

end
