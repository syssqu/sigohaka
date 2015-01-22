class SummaryAttendance < ActiveRecord::Base
	belongs_to :user

	validates :previous_m, numericality: true, allow_blank: true
	validates :present_m, numericality: true, allow_blank: true
end
