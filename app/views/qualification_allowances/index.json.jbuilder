json.array!(@qualification_allowances) do |qualification_allowance|
  json.extract! qualification_allowance, :id, :user_id, :number, :item, :money, :get_date, :registration_no_alphabet, :registration_no_year, :registration_no_month, :registration_no_individual
  json.url qualification_allowance_url(qualification_allowance, format: :json)
end
