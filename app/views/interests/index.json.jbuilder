json.array!(@interests) do |interest|
  json.partial! 'interest', interest: interest
end
