class VacationRequest < ActiveRecord::Base

	validates :user_id, presence: true
  belongs_to :user

	def get_years
		ActiveRecord::Base.connection.select_all("select '20165' as id, '2016年5月度' as value")
	end

end
