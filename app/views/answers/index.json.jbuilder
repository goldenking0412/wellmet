json.array!(@answers) do |answer|
  json.partial! 'answer', locals: { answer: answer }
end
