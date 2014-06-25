json.array!(@qualification_allowances) do |qualification_allowance|
  json.extract! qualification_allowance, :id, :user_id, :number, :item, :money
  json.url qualification_allowance_url(qualification_allowance, format: :json)
end
