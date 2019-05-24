json.array!(@user_blocks) do |user_block|
  json.extract! user_block, :id, :user_id, :blocked_user_id
  json.url user_block_url(user_block, format: :json)
end
