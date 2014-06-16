class Project < ActiveRecord::Base
  belongs_to :user

  validates :summary, presence: true, length: { maximum: 40}
  validates :start_date, presence: true
end
