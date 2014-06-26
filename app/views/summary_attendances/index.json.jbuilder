json.array!(@summary_attendances) do |summary_attendance|
  json.extract! summary_attendance, :id, :user_id, :year, :month, :previous_m, :present_m, :vacation, :half_holiday
  json.url summary_attendance_url(summary_attendance, format: :json)
end
