json.array!(@licenses) do |license|
  json.extract! license, :id, :code, :name, :years, :user_id
  json.url license_url(license, format: :json)
end
