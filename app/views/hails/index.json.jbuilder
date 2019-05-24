json.array!(@hails) do |hail|
  json.extract! hail, :id, :user_id, :to_user_id, :message, :accepted
  json.url hail_url(hail, format: :json)
end
