json.array! @users do |user|
  json.partial! 'user', locals: { user: user }
end
