json.array!(@banner_managements) do |banner_management|
  json.extract! banner_management, :id, :name, :title, :position, :heading, :subtitle1, :subtitle2, :image, :heading_position
  json.url banner_management_url(banner_management, format: :json)
end
