json.array!(@projects) do |project|
  json.extract! project, :id, :code, :name, :remarks
  json.url project_url(project, format: :json)
end
