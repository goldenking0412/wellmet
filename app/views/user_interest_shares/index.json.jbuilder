json.array!(@user_interest_shares) do |user_interest_share|
  json.extract! user_interest_share, :id, :interest_id, :user_id, :to_user_id
end
