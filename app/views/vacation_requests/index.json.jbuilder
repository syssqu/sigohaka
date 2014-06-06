json.array!(@vacation_requests) do |vacation_request|
  json.extract! vacation_request, :id, :user_id, :start_date, :end_date, :term, :category, :reason, :note, :year, :month
  json.url vacation_request_url(vacation_request, format: :json)
end
