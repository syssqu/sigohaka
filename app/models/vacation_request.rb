class VacationRequest < ActiveRecord::Base

	validates :user_id, presence: true
	validate :date_check
  belongs_to :user

	def get_years
		ActiveRecord::Base.connection.select_all("select '20165' as id, '2016年5月度' as value")
	end

	## 「いつまで」の日付が「いつから」より後かをチェック ##
	def date_check
		unless start_date <= end_date then
		 errors[:base] << "正しい日付を入力してください."
		end
	end
end
