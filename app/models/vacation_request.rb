class VacationRequest < ActiveRecord::Base

  belongs_to :user
  validates :user_id, presence: true

  validates :year, length: { maximum: 4 }
  validates :month, length: { maximum: 2 }

end
