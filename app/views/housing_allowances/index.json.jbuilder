json.array!(@housing_allowances) do |housing_allowance|
  json.extract! housing_allowance, :id, :user_id, :year, :month, :reason, :reason_text, :housing_style, :housing_style_text, :agree_date_s, :agree_date_e, :spouse, :spouse_name, :spouse_other, :support, :support_name1, :support_name2, :money
  json.url housing_allowance_url(housing_allowance, format: :json)
end
