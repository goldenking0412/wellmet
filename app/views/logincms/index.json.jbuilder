json.array!(@logincms) do |logincm|
  json.extract! logincm, :id, :content
  json.url logincm_url(logincm, format: :json)
end
