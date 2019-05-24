json.array!(@pages) do |page|
  json.extract! page, :id, :title, :body, :slug, :description, :deactivate
  json.url page_url(page, format: :json)
end
