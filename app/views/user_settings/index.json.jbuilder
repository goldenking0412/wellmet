json.array!(@user_settings) do |user_setting|
  json.extract! user_setting, :id, :user_id, :radius, :common_interests_count, :gender, :ages, :radius_id
  json.url user_setting_url(user_setting, format: :json)
end
