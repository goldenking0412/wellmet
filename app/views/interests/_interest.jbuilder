json.extract! interest,
              :id,
              :name,
              :category_id,
              :all_time_users_count,
              :like_count,
              :dislike_count,
              :comments_count

json.extract! interest, :users_count if interest.respond_to? :users_count

if current_user
  user_interest = current_user.user_interests.where(interest_id: interest.id).first
  json.like user_interest.try(:like)
  json.added interest.users.where(id: current_user.id).first.present?
end
