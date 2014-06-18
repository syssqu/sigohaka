json.array!(@business_reports) do |business_report|
  json.extract! business_report, :id, :user_id, :naiyou, :jisseki, :tool, :self_purpose, :self_value, :self_reason, :user_situation, :request, :reflection, :develop_purpose, :develop_jisseki, :note
  json.url business_report_url(business_report, format: :json)
end
