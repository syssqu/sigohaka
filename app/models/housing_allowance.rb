class HousingAllowance < ActiveRecord::Base
	belongs_to :user

	validate :start_end_check

	def start_end_check

		if !self.agree_date_e.blank? && self.agree_date_s > self.agree_date_e
			errors[:base] << "正しい数値を入力してください"
		end
	end

end
