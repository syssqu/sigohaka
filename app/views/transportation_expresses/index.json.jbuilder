json.array!(@transportation_expresses) do |transportation_express|
  json.extract! transportation_express, :id, :user_id, :koutu_date, :destination, :route, :transport, :money, :note, :sum, :year, :month
  json.url transportation_express_url(transportation_express, format: :json)
end
