json.array!(@user_interests) do |user_interest|
  json.extract! user_interest, :id, :created_at, :comment, :interest_id, :user_id, :like
end
