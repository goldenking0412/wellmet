json.extract!(user,
              :id,
              :username,
              :top_category_id,
              :points,
              :bio,
              :gender,
              :geolocation_updated_at,
              :age,
              :last_chatted_user_id,
              :user_setting,
              :messages,
              :email,
              :provider,
              :location,
              :latitude,
              :longitude,
              :policy,
              :date_of_birth,
              :profilephoto,
              :current_sign_in_at,
              :last_logged_out_at)

if @commmon_user_interests_counts
  json.common_interests_count @commmon_user_interests_counts[user.id] || 0
else
  json.common_interests_count 0
end

json.distance user.distance_from_coordinates(user_cordinates.values) if params[:radius] && user_cordinates.present? && user_cordinates.values

json.online user.geolocation_updated_at.present? &&
  user.geolocation_updated_at >= Time.zone.now - User::ONLINE_TIMEOUT

json.hailed Hail.between_users(current_user.id, user.id).any? if current_user
json.blocked UserBlock.between_users(current_user.id, user.id).any? if current_user

json.hailable user.hail?(current_user) if current_user

json.location user.location if current_user && user == current_user && user.user_setting && user.user_setting.city_visibility == 'public'

distance = user.distance_from_coordinates(user_cordinates.values) if params[:radius] && user_cordinates

if distance
  if distance <= 10
    json.radiicategory "Really close"
  elsif distance <= 50
    json.radiicategory "Close"
  elsif distance <= 250
    json.radiicategory "Far"
  elsif distance <= 1000
    json.radiicategory "Really Far"
  elsif distance > 1000
    json.radiicategory "Far Far away"
  end
end
