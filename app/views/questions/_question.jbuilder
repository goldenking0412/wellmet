json.extract! question, :id, :created_at, :text, :user_id, :answers
json.username question.user.username if question && question.user
json.profilephoto question.user.profilephoto if question && question.user
json.top_category_id question.user.top_category_id if question && question.user
json.user_blocked UserBlock.between_users(current_user.id, question.user_id).any? if current_user
distance = question.user.distance_from_coordinates(user_cordinates.values) if params[:radius] && user_cordinates && question && question.user

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
