json.array!(@messages) do |message|
  json.partial! 'message', locals: { message: message }
end
