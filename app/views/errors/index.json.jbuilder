json.array!(@errors) do |error|
  json.extract! error, :id, :not_found, :internal_server_error
  json.url error_url(error, format: :json)
end
