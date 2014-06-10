json.array!(@attendance_others) do |attendance_other|
  json.extract! attendance_other, :id, :summary, :over_time
  json.url attendance_other_url(attendance_other, format: :json)
end
