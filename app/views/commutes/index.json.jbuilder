json.array!(@commutes) do |commute|
  json.extract! commute, :id, :user_id, :year, :month, :reason, :reason_text, :transport, :segment1, :segment2, :money
  json.url commute_url(commute, format: :json)
end
