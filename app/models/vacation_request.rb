class VacationRequest < ActiveRecord::Base

	validates :user_id, presence: true
	validate :date_check
  belongs_to :user

	def date_check
		unless start_date <= end_date then
		 errors[:base] << "正しい日付を入力してください."
		end
  end
end
